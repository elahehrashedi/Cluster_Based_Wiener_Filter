%Elaheh Rashedi

function [ cluster_matrix ] = ChangeCluster( R , C , N , M ,cluster_matrix , num_of_clusters )

    %this function basically do a filtering on clusters

    cluster_matrix2 = cluster_matrix;
    for j = 1:C                 
        for i = 1:R
            temp1 = cluster_matrix2 (i,j);
            clus_counter = zeros (num_of_clusters,1) ; 
            minM = j - (M-1)/2 ; if (minM<1) minM=1; end
            maxM = j + (M-1)/2 ; if (maxM>C) maxM=C; end
            minN = i - (N-1)/2 ; if (minN<1) minN=1; end
            maxN = i + (N-1)/2 ; if (maxN>R) maxN=R; end
            for jwin = minM:maxM
                for iwin=minN:maxN
                    temp2 = cluster_matrix2(iwin,jwin);
                    clus_counter (temp2) = clus_counter (temp2) +1 ;
                end
            end
            threashold = N*M/2;
            if clus_counter (temp1) < threashold
                [maxA,index] = max(clus_counter(:));
                cluster_matrix (i,j) = index ; 
            end
        end
    end
end

