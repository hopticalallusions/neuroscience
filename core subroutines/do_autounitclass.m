
unitclassnames=[]; unitclassnumbers=[];
for unitind=1:length(dounits);
    unitj=dounits(unitind);
        
    classify_unitj

    unitclassnames{unitj}=unitIDname;
    unitclassnumbers=[unitclassnumbers unitIDnumber];
    
end

unitproperties.unitclassnames=unitclassnames;
unitproperties.unitclassnumbers=unitclassnumbers;
save([unitclassdir 'unitproperties.mat'], 'unitproperties', '-MAT')

disp(['done classifying units, added IDs to unitproperties.'])
disp(['*****************************results:'])
disp(['       ' num2str(100*length(find(unitclassnumbers==1))/length(dounits)) ' % units are ' celltype1])
disp(['       ' num2str(100*length(find(unitclassnumbers==2))/length(dounits)) ' % units are ' celltype2])
disp(['       ' num2str(100*length(find(unitclassnumbers==3))/length(dounits)) ' % units are ' celltype3])
disp(['       ' num2str(100*length(find(unitclassnumbers==0))/length(dounits)) ' % units are ' celltype0])
disp(['************************************'])
