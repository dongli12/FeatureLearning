
for im_per_class = [1 5 10 50 100 500]

    [ims,label] = textread('cifar_train/img_list.txt','%s %d');
    num_im = length(ims);
    
    %scrambble
    perm_idx = randperm(num_im);
    ims = ims(perm_idx);
    label = label(perm_idx);

    filename = sprintf('cifar_train_sample/%d_perC.txt',im_per_class);
    fid = fopen(filename,'w');
    
    class_num = 10;
    
    pick_idx = [];
    for c = 0 : (class_num-1)
        c_idx = find(label == c)';
        idx_n = min(length(c_idx),im_per_class);
        pick_idx = [pick_idx c_idx(1:idx_n)];
    end

    pick_num = size(pick_idx, 2);

    ims = ims(pick_idx);
    label = label(pick_idx);

    for i = randperm(pick_num)
        fprintf(fid,'%s %d\n', ims{i}, label(i));
    end

    fclose(fid);

end
