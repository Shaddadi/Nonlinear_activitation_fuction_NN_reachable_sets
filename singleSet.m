function Polyh = singleSet(subZ, s)
    n = 5; % number of neuron 
     
    Az = subZ.H(:,1:end-1);
    bz = subZ.H(:,end);
    Az2 = [Az, zeros(size(Az,1), n)];
    
    Ay = zeros(2*n); by =[];
    t = 0;
    for i = 1:n
        t = t + 1;
        Ay(t,n+i) = -1;
        Ay(t,i) = s(i,1);
        by(t,:) = -s(i,2);
        t = t + 1;
        Ay(t,n+i) = 1;
        Ay(t,i) = -s(i,3);
        by(t,:) = s(i,4);       
    end
    
    Ap = [Az2; Ay];
    bp = [bz; by];
    Ph = Polyhedron(Ap, bp);
    Al = [zeros(n),eye(n)];
    Polyh = Al*Ph;
%     plot(Polyh);
%     hold on
end