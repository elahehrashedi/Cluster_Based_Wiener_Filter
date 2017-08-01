%Elaheh Rashedi

function [ cluster_matrix , num_of_clusters ] = Hclustering( R , C , upload_cluster, cluster_filename , upload_cluster_matrix, cluster_matrix_filename , num_of_clusters , norm_Intensity , norm_u_coef , features , cutoff , s_variance )

    %====================CALCULATE CLUSTERING=====================

    if upload_cluster == 1
            % creating unsimilarity distance matrix for clustering
            load(cluster_filename,'Z','Y'); % load distance from file
    else

        X = zeros (R*C,features);
        %X = zeros (R*C,2);
        Y = zeros (R*C,2);

    % Intesity      
    if features==1 
        counter = 1 ;
        for j=1:C
            for i=1:R
                %X (counter,1) = norm_Intensity(i,j);
                X (counter,2) = norm_u_coef(i,j);
                Y (counter,1) = j ;
                Y (counter,2) = -i ;
                counter = counter + 1 ;
            end
        end
    % Intesity attenuation 
    elseif features==2
        counter = 1 ;
        for j=1:C
            for i=1:R
                X (counter,1) = norm_Intensity(i,j);
                X (counter,2) = norm_u_coef(i,j);
                Y (counter,1) = j ;
                Y (counter,2) = -i ;
                counter = counter + 1 ;
            end
        end
    elseif features==3
        counter = 1 ;
        for j=1:C
            for i=1:R
                X (counter,1) = norm_Intensity(i,j);
                X (counter,2) = norm_u_coef(i,j);
                X (counter,3) = s_variance(i,j);
                Y (counter,1) = j ;
                Y (counter,2) = -i ;
                counter = counter + 1 ;
            end
        end

    end

        tic;
        cluster_timer = 0
        %Z = linkage(X,'average','euclidean');
        %Z = linkage(X,'single','euclidean');
        Z = linkage(X,'ward','euclidean','savememory','on'); %minimum variance
        %Z = linkage(X,'centroid','euclidean','savememory','on');
        %Z = linkage(X,'median','euclidean','savememory','on');
        cluster_timer = toc
        save(cluster_filename,'Z','Y'); 

    end

    %=================CALCULATE CLUSTERING MATRXI=================

    if upload_cluster_matrix == 1
            load(cluster_matrix_filename,'cluster_matrix'); 
    else
        if cutoff == 0
            clus = cluster(Z,'maxclust',num_of_clusters);
        else % cutoff == 1
            clus = cluster(Z,'cutoff',0.8);
        end
        figure, scatter(Y(:,1),Y(:,2),10,clus); title('\color{magenta}clustering result');
        cluster_matrix = zeros (R,C);
        % creating the cluster matrix
        counter = 1 ;
        for j=1:C
            for i=1:R
                %if ()
                cluster_matrix (i,j) = clus (counter);
                counter = counter + 1;
            end
        end
        save(cluster_matrix_filename,'cluster_matrix'); 
    end


end

