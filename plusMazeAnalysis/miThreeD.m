function [ jointMI, condMI, entropy, phaseMImat, expectationViolation  ] = miThreeD( probJointData, probOccupyXY )

    % This is a purpose-built function for calculating MI on a X by Y by Z
    % matrix of joint probabilities. X & Y are position data. Z is some
    % neural measure, such as firing rate or firing phase.
    %
    % The joint is based on the standard joint calculations. The
    % conditional is based on normalizing the joint value by the known
    % value, which in the case for which this is intended is always
    % position.
    %
    % This function assumes that the 3rd dimension is the not-XY data.
    %
    % It turns out that variable width binning to generate uniform marginal
    % distributions is actually not a bad thing, and in fact can have
    % advantages. see PMC 6131830 for example.
    %
    
    if ( nansum(probJointData(:)) < .99 ) || ( nansum(probJointData(:)) > 1.01 ); 
        jointMI = NaN; condMI = NaN; entropy=NaN;  phaseMImat=NaN; expectationViolation=NaN; return;
        %warning('BAD probJointData!!!'); 
    end;
    
    if nargin < 2
        probOccupyXY = nansum(probJointData,3);
    end
    if ( nansum(probOccupyXY(:)) < .99 ) || ( nansum(probOccupyXY(:)) > 1.01 );
        % warning('BAD probOccupyXY!!!'); 
        jointMI = NaN; condMI = NaN; entropy=NaN;  phaseMImat=NaN; expectationViolation=NaN; return;
    end;
    
    probSpikeMetric = squeeze(nansum(squeeze(nansum(probJointData,2))));
    if ( nansum(probSpikeMetric(:)) < .99 ) || ( nansum(probSpikeMetric(:)) > 1.01 ); 
        % warning('BAD probPhase!!!'); 
        jointMI = NaN; condMI = NaN; entropy=NaN; phaseMImat=NaN; expectationViolation=NaN;  return;
    end;

    %% calculate the joint mutal information
    %
    % MI = sum { p(x,k) * log2( p(k,x) / ( p(k)*p(x) ) )   }
    %
    % here, x is position, which is technically a 2d matrix, but it can
    % safely be treated as a 1d variable for MI
    % k is the spike metrix, e.g. phase, firing rate, etc.
    %
    % as I understand it, the fractional component gives the ratio of the
    % joint probability over the chance that two unconnected random
    % variables would coincide at that joint location. This allows the
    % calculation to "figure out" if the probability of the joint is above
    % chance (if it is not, the result is <= 0).
    %
    % MI will return zero (theoretically) for unrelated random variables
    % (however, simulating random variables with matlab results in an MI of
    % about .25, although perhaps this is because they are not truly
    % random. This result becomes more finely tuned for larger matrices. 
    % see below return statement for more.)
    %
    % returning zero requires negative numbers in the presence of noise, as
    % the negative values counterbalance the positive values.
    %
    % Refs :
    %
    % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6364943/#!po=9.48276
    % Monaco ... Blair ... et al. Spatial synchronization codes from
    %        coupled rate-phase neurons. PloS Comp Bio 2019 Jan
    %
    % Contains formula implemented below. 
    %
    % Timme & Lapish. A Tutorial for Information Theory in Neuroscience.
    % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6131830/
    %
    % Contains pointers for interpretation; basic instruction, etc
    %
    % Prof. Mai Vu. Tufts University EE194; Network Information Theory; Electrical and Computer Engineering
    % "lect01.pdf" -- contains comprehensible proof showing that MI must be
    % greater than or equal to zero based on the expected value of the
    % summation (not individual elements); therefore, it is not valid to
    % throw out negative values. If the calculation comes back negative,
    % the code or inputs are bad.
    %
    % Cover & Thomas 2006. Elements of Information Theory.
    %    -- complete text. available as ebook through UCLA library.
    %
    % https://www.seas.upenn.edu/~cis391/Lectures/probability-bayes-2015.pdf
    % also helpful
    % 
    phaseMImat = zeros(size(probJointData));
    condMImat = zeros(size(probJointData));
    expectationViolation = zeros(size(probJointData));
    sz=size(probJointData);
    
    for rr=1:sz(1)
        for cc=1:sz(2)
            for dd=1:sz(3)
                % division by zero causes problems, so we will exclude
                % these (MI cannot be infinite)
                % 
                % negative information values ARE NOT IGNORED. see refs above
                if ( probOccupyXY(rr,cc) * probSpikeMetric(dd) ) > 0
                    % the eps prevents log(0) by adding the smallest
                    % possible floating point number.
                    expectationViolation(rr,cc,dd) = log2( eps + probJointData(rr,cc,dd) / ( probOccupyXY(rr,cc) * probSpikeMetric(dd) ) );
                    phaseMImat(rr,cc,dd) = probJointData(rr,cc,dd) * expectationViolation(rr,cc,dd);
                    condMImat(rr,cc,dd) = phaseMImat(rr,cc,dd) / probOccupyXY(rr,cc);
                end
            end
        end
    end
    
    jointMI = nansum(phaseMImat(:));
    
    %% calculate the conditional mutual information. 
    % the conditional formulation is from e.g. 
    % conditional information is a normalization over the joint
    % probability. i.e. in a 2d matrix of joint probabiltilties, if we
    % calculate the conditional probability (that is, the p(k) given x --
    % p(k|x) ) instead of say, .04 for the joint, we can get .8 if the
    % state X has a probability of .05 (becuase one divides .04 by .05 to
    % reflect the newly restricted probabilities.)
    %
    % MI = sum { p(k,x) * log2( p(k,x) / ( p(k)*p(x) ) )   }
    % CI = sum { p(k|x) * log2( p(k|x) / ( p(k) ) )   }
    %    p(k|x) = p(k,x) / p(x)
    % CI = sum { p(k,x) / p(x) * log2( p(k,x) / ( p(k)*p(x) ) )  }
    % CI = sum { MI_i / p(x) }
    %
    % Refs :
    % Tingley & Buzsaki 2018
    % Olypher et al. / Journal of Neuroscience Methods 127 (2003)
    
    condMI = nansum(condMImat(:));
    
    
    
    probOccupyXY( (abs(probOccupyXY) == Inf) | (probOccupyXY == 0) ) = NaN;
    probSpikeMetric( (abs(probSpikeMetric) == Inf) | (probSpikeMetric == 0) ) = NaN;
    
    entropy.occupancy = nansum(nansum(  probOccupyXY .* log2(1./probOccupyXY)  ));
    entropy.spikeMetric = nansum(  probSpikeMetric .* log2(1./probSpikeMetric)  );
    
    
return; 

    % This is a contrived example to demonstrate how to perform the
    % calculation in a valid way
    %
    % Mutual Information (MI) is a super general, abstract way to measure if two
    % things are related or not. The MI will be zero (theoretically) if the
    % variables are completely unrelated (but see below for a practical
    % example). Because it operates on probability values in bins, it works
    % on nonlinear data.
    %
    % (1) has a good, clear proof that shows that the sum of each
    % individual calculations that go into MI must be greater than zero. 
    % It does NOT show that each individual calculation must be zero. 
    % ( See the first example code below for a valid joint distribution 
    % which produces negative individual calculations. ) Because MI will 
    % result in zero for unrelated values, and it will be impossible for 
    % the sum to be zero without some negative values to counterbalance 
    % instances where things have co-occurred by chance, it is NOT VALID to
    % throw out instances where an individual calculation is zero. 
    % HOWEVER, the sum at the end should *never be less than zero*.
    %
    % This makes sense from the perspective that MI can measure whether
    % knowing something about one variable allows us to have more
    % confidence in the value of another variable. The fraction that goes
    % into the log is the ratio of the joint probability divided by the
    % probability that a coincidence from the individual probabilities that
    % the variables could occupy that cell by chance. If the fraction is
    % <= 1, it tells us that the joint probability (that is, knowing
    % something about one or the other variable) doesn't tell us anything
    % useful about the state of the other variable for that entry.
    % Fractional values as inputs to the log probably tell us that we don't
    % have very good sampling, as unrelated variables should eventually
    % converge on having their joint probability be equal to the product of
    % their individual not-joint probabilities.
    %
    %
    % refs :
    % 
    % (1) MI Lecture Notes, esp. pg 6 -- https://www.ece.tufts.edu/ee/194NIT/lect01.pdf
    % (2) MI Textbook -- Elements of Information Theory; 2nd Ed; Thomas M. Cover and Joy A. Thomas; 2006 John Wiley & Sons, Inc.
    % (3) MI in Neuroscience -- https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6131830/
    
    pkx = [ 0 .1 .1; 0 .1 .5; .2 0 0 ]
    pk = sum(pkx)
    px = sum(pkx,2)
    mikx = zeros(3,3);

    pkx
    for cc=1:3
        for rr=1:3
            mikx(cc,rr) = pkx(cc,rr) * log2( pkx(cc,rr) / ( pk(rr) * px(cc) ) );
            disp( ['mikx(' num2str(cc) ',' num2str(rr) ') = ' num2str(pkx(cc,rr)) ' * log2( ' num2str( pkx(cc,rr) ) '/ {' num2str( pk(rr)) ' * ' num2str(px(cc) ) '}' ])
        end
    end

    mikx
    nansum(mikx(:))
    
    
    % compare e.g. 3x3 matrix to 20x30 to 200x300
    
    infoVals = zeros(1,1000);
    negPosRatio = zeros(1,1000);
    matrixDim = [ 100 200 ];
    for ii=1:1000
        fkx = randi(100,matrixDim(1),matrixDim(2));
        pkx = fkx./sum(fkx(:));
        pk = sum(pkx);
        px = sum(pkx,2);
        mikx = zeros(matrixDim(1),matrixDim(2));

        for cc=1:matrixDim(1)
            for rr=1:matrixDim(2)
                mikx(cc,rr) = pkx(cc,rr) * log2( pkx(cc,rr) / ( pk(rr) * px(cc) ) );
            end
        end
        infoVals(ii) = nansum(mikx(:));
        negPosRatio(ii) = sum((mikx(:)<0))/sum((mikx(:)>0));
    end
    
   figure; histogram( infoVals, 100);
   figure; histogram( negPosRatio, 100);
    
end


