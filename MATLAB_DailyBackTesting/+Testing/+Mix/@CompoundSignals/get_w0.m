function w0 = get_w0(obj, Date)
    
    w0 = containers.Map;
      
    for ii = 1:length(obj.THPath)
        
        FileName = [obj.THPath{ii}, num2str(Date), '.mat'];
        if exist(FileName, 'file')
            load(FileName); % µº»ÎTargetHolding
        else
            continue
        end
        
        % º∆À„w0
        for jj = 1:size(TargetHolding, 1)
            Contract = TargetHolding{jj,1};
            if isKey(w0, Contract)
                w0(Contract) = w0(Contract) + sign(TargetHolding{jj,2});
            else
                w0(Contract) = sign(TargetHolding{jj,2});
            end
        end
        
    end
    
 end
        



