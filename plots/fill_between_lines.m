function fill_between_lines(X,Y1,Y2,C) 
	h=fill( [X fliplr(X)],  [Y1 fliplr(Y2)], C );
	set(h,'EdgeColor','none');
end