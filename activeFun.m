function y = activeFun(x,activeType) 
switch activeType
    case 'tansig'
        y = tansig(x);
    case 'logsig'
        y = logsig(x);
    case 'purelin'
        y = purelin(x);
    case 'overTanSig'
        y = overTanSig(x);
    case 'underTanSig'
        y = underTanSig(x);
    case 'tansigover'
        y = tansigover(x);
    case 'tansigunder'
        y = tansigunder(x);
    case 'piecewise'
        y = piecewise(x);
end