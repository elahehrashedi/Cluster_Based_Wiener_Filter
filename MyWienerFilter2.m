%Elaheh Rashedi

function [ filtered_Intensity ] = MyWienerFilter2 ( R , C , N , M , Intensity , cluster_matrix , num_of_clusters , var_window , cluster_win_size)

    %MyWienerFilter uses global mean and max for each pixel
    %MyWienerFilter2 uses local mean and max for each pixel
    % the method #2 is prefered to #1 and creates better results

    % R is number of rows of image (depth) 
    % C is number of columns of image 
    % N is the row size (depth) of window for filtering <R>
    % M is the column size of window for filtering <C>
    filtered_Intensity = zeros (R,C);
    mean_mat = zeros (R,C);
    var_mat = zeros (R,C);
    noise_var = zeros (num_of_clusters,2);
    for j=1:C
        for i=1:R
            
            pixel_cluster = cluster_matrix (i,j);
            if (var_window==1) 
                M = cluster_win_size (pixel_cluster);
                N = M ;
            end
            % calculate the window N*M around each pixel
            minM = j - (M-1)/2 ; if (minM<1) minM=1; end
            maxM = j + (M-1)/2 ; if (maxM>C) maxM=C; end
            minN = i - (N-1)/2 ; if (minN<1) minN=1; end
            maxN = i + (N-1)/2 ; if (maxN>R) maxN=R; end

            %mywindow = NaN (N*M,1,'double'); % maximum widow size
            mywindow = zeros (1,1);
            k = 0 ; % number of pixels in the window with same clustering number as reference pixel               
            for wj = minM : maxM
                for wi = minN : maxN
                    if pixel_cluster == cluster_matrix (wi,wj)
                        k = k + 1;
                        mywindow(k) = Intensity (wi,wj);
                    end
                end
            end        
            mean_mat (i,j) = mean (mywindow) ;
            var_mat (i,j) = var(mywindow);
            noise_var(pixel_cluster,2) = noise_var(pixel_cluster,2) + var_mat (i,j) ; % calculating the noise variance in each cluster 
            noise_var(pixel_cluster,1) = noise_var(pixel_cluster,1) + 1 ;
        end
    end

    %If the noise variance is not given, wiener2 uses the average of all the local estimated variances.
    for i=1:num_of_clusters
        noise_var(i,2)=noise_var(i,2)/noise_var(i,1);
    end

    %modified wiener2 formula
    for j=1:C %change
        for i=1:R % change
            % calculate local noise variane
            pixel_cluster = cluster_matrix (i,j);
            pixel_noise_var = noise_var(pixel_cluster,2);
            % FORMULA1 = localMean + (max(0, localVar - noise) ./ max(localVar, noise)) .* (g - localMean);
            a = mean_mat (i,j) ;
            b = ( max(0,var_mat(i,j)-pixel_noise_var) / max (var_mat(i,j),pixel_noise_var) ) *( Intensity (i,j) - mean_mat (i,j) );
            filtered_Intensity (i,j) = a + b  ;
            my(i,j) = (b / a) * 100 ;
        end
    end
end

