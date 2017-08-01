%Elaheh Rashedi

function [ cluster_win_size ] = window_size( R , C , N , M ,cluster_matrix , num_of_clusters,speckle_matrix )

    % first element shows the summation of densities , the second element showes the number of elements in cluster    
    density = zeros (num_of_clusters,2) ; 
    cluster_win_size = zeros (num_of_clusters);
    for j = 1:C                 
        for i = 1:R
            cluster_number = cluster_matrix (i,j);
            specklevalue = speckle_matrix (i,j) ;
            if (specklevalue ~= 0)
                density (cluster_number,1) = density (cluster_number,1) + specklevalue ;
                density (cluster_number,2) = density (cluster_number,2) + 1 ;
            end
        end
    end
    
    newdensity = density (:,1) ./ density(:,2) ;   
    cluster_win_size = [5,7,7,5,3] ;

end

