%Elaheh Rashedi

function [ output_file ] = SkinProcessor( tif0_mat1 , input_file , R , C , upload_distance , upload_cluster , upload_cluster_matrix , num_of_clusters , cutoff , distance_filename , cluster_filename , cluster_matrix_filename , N , M , features , iteration_number , smooth , Threashold , var_window)
    clc; close all; %clear all; 

    output_file = sprintf('%d_%d/X_%d_%d_output#%d.tif',R,C,R,C,iteration_number);    
    
    
    %=============================================================
    %=======================SHOW IMAGE============================

    if tif0_mat1 == 0
        % save image to matrix
        log_Intensity = imread (input_file); 
        log_Intensity = log_Intensity (:,:,1); %for C-scan image
        figure, imshow (log_Intensity,[]); title('\color{magenta}imread main image');    

        log_Intensity = im2double(log_Intensity);     
        %figure, imshow (Intensity,[]); title('\color{magenta}im2double image 2');
    else
        load(input_file,'A');
        %x = 10 ; y = 550 ;
        x=1; y=1;
        log_Intensity = A (x:x+R-1,y:y+C-1,1);
        %figure, imshow (log_Intensity,[]); title('\color{magenta} log image 3');

        
    end
    % unlog OCT image
    unlog_Intensity = unlogOCT( log_Intensity ) ;
    %figure, imshow (unlog_Intensity,[]); title('\color{magenta} unlog image 3');

    %Intensity4 = 10 .* log10(Intensity3) ;
    %figure, imshow (Intensity4,[]); title('\color{magenta}log image 3');
  
	norm_unlog_Intensity = MatrixNorm (unlog_Intensity); % we are using unlog image every where othernthan attenuation
    norm_log_Intensity = MatrixNorm (log_Intensity);
    %figure,imshow (norm_Intensity,[]); title('\color{magenta}normalized image');
    
    snr_initial = SNR2 (norm_unlog_Intensity,norm_unlog_Intensity);
    %=============================================================
    %=========================SUPRESS SPECKLES====================
    
    s_variance = SupressSpeckles ( R , C , N , M , norm_unlog_Intensity , Threashold ) ;
    %Supress_Intensity = SupressSpeckles ( R , C , N , M , norm_unlog_Intensity , Threashold ) ;     
    %norm_unlog_Intensity = MatrixNorm (Supress_Intensity);
    %figure,imshow (norm_unlog_Intensity,[]); title('\color{magenta}normalized suppress image');
    
    %=============================================================
    %====================CALCULATE ATTENUATION====================
    norm_u_coef = zeros (R,C);
    if (upload_cluster==0)
        %norm_u_coef = Attenuation ( R , C , norm_Intensity ); 
        norm_u_coef = Attenuation2 ( R , C , norm_log_Intensity ); % use log intensity for attenuation
    end
    %=============================================================
    %====================CALCULATE DISTANCE=======================

    %distance  = DistanceFunc( upload_distance, distance_filename, R , C , norm_u_coef );
    
    %=============================================================
    %========================CLUSTERING===========================

    %use unlog intensity
    [cluster_matrix , num_of_clusters] = Hclustering( R , C , upload_cluster, cluster_filename , upload_cluster_matrix, cluster_matrix_filename , num_of_clusters , norm_unlog_Intensity , norm_u_coef , features , cutoff , s_variance);

    %=============================================================
    %======================change cluster=========================

    % modify cluisters, this can be considered as a filtering on clusters
    cluster_matrix_smooth = ChangeCluster( R , C , N , M ,cluster_matrix , num_of_clusters );
    %show the new filtered clustering
    v = reshape(cluster_matrix_smooth ,numel(cluster_matrix_smooth),1);
    c=1; Y=zeros(R*C,2);
    for j=1:C
        for i=1:R  
            Y(c,1)=j; 
            Y(c,2) = -i; 
            c=c+1; 
        end  
    end    
    figure, scatter(Y(:,1),Y(:,2),10,v); title('\color{magenta}smooth clustering result');

    %=============================================================
    %====================== Speckle Statistics====================
    
    if (var_window == 1) % if we need variable statistics to change window size
        norm_unlog_layer2 = MatrixNorm (unlogOCT( A (x:x+R-1,y:y+C-1,2)));% to compute correlation
        norm_unlog_layer3 = MatrixNorm (unlogOCT( A (x:x+R-1,y:y+C-1,3)));
        norm_unlog_layer4 = MatrixNorm (unlogOCT( A (x:x+R-1,y:y+C-1,4)));
        %calculate the mean density of speckle for a window of size MxN around
        %each pixel
        speckle_matrix = Speckle_Density (norm_unlog_Intensity , norm_unlog_layer2 , norm_unlog_layer3 , norm_unlog_layer4 , N , M , R , C) ;
        %calculate the size of window for each cluster
        cluster_win_size = window_size (R , C , N , M ,cluster_matrix_smooth , num_of_clusters,speckle_matrix) ;
    else
        cluster_win_size = [5,5,5,5,5] ; 
    end
    %=============================================================
    %======================Our Wiener Filter =====================
    
    if smooth == 0 % non smoothing
        %filter the image according to clustering matrix before change
        filtered_Intensity = MyWienerFilter2( R , C , N , M , norm_unlog_Intensity , cluster_matrix , num_of_clusters , var_window , cluster_win_size );
        
        non_smooth_snr = SNR2 (norm_unlog_Intensity,filtered_Intensity);
        
        %here we log back again the OCT image
        filtered_Intensity = logOCT (filtered_Intensity) ; 
        figure, imshow (filtered_Intensity,[]) ; title('\color{magenta}Our filtered image before cluster smoothing');
        
    end
    
    if smooth == 1 % smoothing
        %filter the image according to clustering matrix after change
        %this is prefered
        filtered_Intensity2 = MyWienerFilter2( R , C , N , M , norm_unlog_Intensity , cluster_matrix_smooth , num_of_clusters , var_window , cluster_win_size);
        
        smooth_snr = SNR2 (norm_unlog_Intensity,filtered_Intensity2);
        
        %here we log back again the OCT image
        %filtered_Intensity2 = logOCT (filtered_Intensity2) ;
        figure, imshow (filtered_Intensity2,[]) ; title('\color{magenta}Our filtered image after cluster smoothing');
        
    end
    
    % compare to wiener2
    [J,noise] = wiener2(norm_unlog_Intensity,[N M]) ;
    figure, imshow (J,[]) ; title('\color{magenta}wiener image');
    wiener_snr = SNR2(norm_unlog_Intensity,J);

    %=============================================================
    %=============================================================
    % save results of normalization in a picture
    
    % non smoothing result
    if smooth == 0 % non smoothing
        imwrite(filtered_Intensity,output_file);
    end
    if smooth == 1 %  smoothing result
        imwrite(filtered_Intensity2,output_file);
    end
    
    %=============================================================
    %=============================================================
     
end

