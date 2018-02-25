function load_AmountMat(obj)

    load('..\00_DataBase\Edited_Factor\Amount\AmountMat.mat', 'AmountMat')
    obj.AmountMat = AmountMat;
    
end