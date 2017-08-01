%Elaheh Rashedi

function [ filtered_Intensity ] = MyWienerFilter( R , C , N , M , Intensity , cluster_matrix , num_of_clusters)

    %MyWienerFilter uses global mean and max for each pixel
    %MyWienerFilter2 uses local mean and max for each pixel

    % R is number of rows of image (depth) 
    % C is number of columns of image 
    % N is the row size (depth) of window for filtering <R>
    % M is the column size of window for filtering <C>

    filtered_Intensity = zeros (R,C);
    mymean = zeros (num_of_clusters,1);
    myvar = zeros (num_of_clusters,1);
    %find mean and var for each cluster
    for i=1:num_of_clusters
            index = find (cluster_matrix == i) ;
            mymean(i)=mean2(Intensity(index));
            myvar(i)=var(Intensity(index));
    end

    noise = mean2(myvar);
    noiseclus = zeros (num_of_clusters,2);
    for j=1:C
        for i=1:R
            pixel_cluster = cluster_matrix (i,j);
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
            noiseclus(pixel_cluster,2) = noiseclus(pixel_cluster,2) + var(mywindow) ; % calculating the noise variance in each cluster 
            noiseclus(pixel_cluster,1) = noiseclus(pixel_cluster,1) + 1 ;
        end
    end

    for i=1:num_of_clusters
        noiseclus(i,2)=noiseclus(i,2)/noiseclus(i,1);
    end

    %modified wiener2 formula
    % Compute result
    % f = localMean + (max(0, localVar - noise) ./ max(localVar, noise)) .* (g - localMean);
    for j=1:C
        for i=1:R
            pixelcluster = cluster_matrix (i,j);
            pixelvar = myvar(pixelcluster); % var of cluster
            pixelmean = mymean(pixelcluster); % mean of cluster
            noise = noiseclus(pixelcluster,2) ;
            % FORMULA1 = localMean + (max(0, localVar - noise) ./ max(localVar, noise)) .* (g - localMean);
            %filtered_Intensity (i,j) = pixelmean + ( max(0,pixelvar-noise) / max (pixelvar,noise) ) *( Intensity (i,j) - pixelmean ) ;
            % FORMULA2 = clusterMean + (max(0, clusterVar - noise) ./ max(clusterVar, noise)) .* (g - clusterMean);
            filtered_Intensity (i,j) = pixelmean + ( max(0,pixelvar-noise) / max (pixelvar,noise) ) *( Intensity (i,j) - pixelmean ) ;
        end
    end

end

