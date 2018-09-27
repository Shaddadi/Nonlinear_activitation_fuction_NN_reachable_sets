function y = piecewise(x)
for i = 1:length(x)
    if x(i)<=-1
        y(i,:) = -1;
    end
    if (x(i)>-1)&(x(i)<1)
        y(i,:) = x(i);
    end 
    if x(i)>=1
        y(i,:) = 1;
    end
end