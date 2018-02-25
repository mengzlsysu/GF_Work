function TargetHolding = generate_TargetHolding(obj, Date)

    obj.get_THPath();
    w0 = get_w0(obj, Date);
    w0_keys = w0.keys;
    
    for ii = 1:length(w0_keys)
        TargetHolding{ii, 1} = w0_keys{ii};
        w(ii) = w0(w0_keys{ii});       
    end
    
    if ~exist('w', 'var')
        TargetHolding = {};
        return
    end
    w = w/sum(abs(w));

    TargetHolding(:, 2) = num2cell(w);
    
    index = find(w == 0);
    TargetHolding(index, :) = [];
     
end