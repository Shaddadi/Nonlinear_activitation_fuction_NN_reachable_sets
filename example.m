%% Example 2
clear
close all
addpath('../');
network.weight = {randn(5,3), randn(2,5)};
network.bias = {randn(5,1), randn(2,1)};
network.activeType = {'tansig','purelin'} ;
% load network
%constuct Polyh for input and Z
input.min = [-1,-1, -1];
input.max = [1,1, 1];
inputP = Polyhedron([input.min(1), input.min(2), input.min(3);...
    input.min(1), input.max(2), input.min(3);...
    input.max(1), input.min(2), input.min(3);...
    input.max(1), input.max(2), input.min(3);...
    input.min(1), input.min(2), input.max(3);...
    input.min(1), input.max(2), input.max(3);...
    input.max(1), input.min(2), input.max(3);...
    input.max(1), input.max(2), input.max(3)
    ]);
layerZ1 = cell2mat(network.weight(1))*inputP + cell2mat(network.bias(1));
layerZ1.computeHRep;
Az1 = layerZ1.H;
Az1e = layerZ1.He;
lineqZ1 = [Az1; Az1e; -Az1e];

%% divide activation function into 3 sections
% flinear = [0, -1, 0, -tanh(1);...
%     (1+tanh(1))/2, -(1-tanh(1))/2, (1 + tanh(1))/2, (1-tanh(1))/2;...
%      0, tanh(1), 0, 1];
flinear = [0, -1, 0, -0.75;...
    (1+0.75)/2, -(1-0.75)/2, (1 + 0.75)/2, (1-0.75)/2;...
     0, 0.75, 0, 1];
% flinear = [0, -1, 0 ,-1;...
%     1,0, 1,0;
%     0, 1, 0, 1;];

x = -5:0.0001:-1;
plot(x,flinear(1,1)*x+flinear(1,2),'r');hold on;
plot(x,flinear(1,3)*x+flinear(1,4),'r');
x = -1:0.0001:1;
plot(x,flinear(2,1)*x+flinear(2,2),'r');
plot(x,flinear(2,3)*x+flinear(2,4),'r');
x = 1:0.0001:5;
plot(x,flinear(3,1)*x+flinear(3,2),'r');
plot(x,flinear(3,3)*x+flinear(3,4),'r');
x = -5:0.0001:5;
plot(x, tansig(x),'b')

%% divide Polyh Z w.r.t z<-1, -1<=z<=1, z>-1
Zd = {};
Zd(1) = {[1,-1]};
Zd(2) = {[1 1;-1 1]};
Zd(3) = {[-1,-1]};

%% construct sub-layerZ1 w.r.t z's range
%num1 = 3; %number of neurons in 1st hidden layer
num2 = 3; %number of sections in activation fuction
PolyhSets={};
t = 1;
for n1 = 1:num2
    for n2 = 1:num2
        for n3 = 1:num2
            for n4 = 1:num2
                for n5 = 1:num2

                    Zdn1 = cell2mat(Zd(n1));
                    Zdn2 = cell2mat(Zd(n2));
                    Zdn3 = cell2mat(Zd(n3));
                    Zdn4 = cell2mat(Zd(n4));
                    Zdn5 = cell2mat(Zd(n5));
                    
                    Adz = blkdiag(Zdn1(:,1),Zdn2(:,1),Zdn3(:,1),Zdn4(:,1),Zdn5(:,1));
                    Adz = [Adz, [Zdn1(:,2); Zdn2(:,2); Zdn3(:,2); Zdn4(:,2); Zdn5(:,2)]];
                    tempH = [];
                    tempH = [lineqZ1;Adz];
                    subSet = Polyhedron(tempH(:,1:end-1), tempH(:,end));
                    if subSet.isEmptySet()
                        continue;
                    end
                    s = flinear([n1, n2, n3, n4, n5],:);
                    P = singleSet(subSet, s);
                    P.minHRep();
                    P.minVRep();
                    PolyhSets(t) = {cell2mat(network.weight(2))*P + cell2mat(network.bias(2))};
                    t = t+1;
                end
            end
        end
    end
end
%% plot polyhedrons
figure
for i = 1:length(PolyhSets)
    PolyhSets{1,i}.minVRep();
    PolyhSets{1,i}.minHRep();
    plot(PolyhSets{1,i})
    hold on
end
%% Generate random points
%figure
num_sim = 5000;
for i = 1:1:num_sim
    u = [input.min(1)+ (input.max(1)-input.min(1))*rand;...
        input.min(2)+ (input.max(2)-input.min(2))*rand;...
        input.min(3)+ (input.max(3)-input.min(3))*rand];
    NNoutput = networkOutputSingle(u,network);
    plot(NNoutput(1),NNoutput(2),'.','color','c');
    hold on;
end
