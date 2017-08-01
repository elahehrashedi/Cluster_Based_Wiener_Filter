%Elaheh Rashedi

function [ distance ] = DistanceFunc( upload_distance, distance_filename, R , C , norm_u_coef )

    %normalize the depth on each A-scan, means on each column
    depth = transpose (1:R) ;
    norm_depth = normc (depth) ;
    xvalue = transpose (1:C) ;
    norm_xvalue = normc (xvalue) ;

    if upload_distance == 1
            % creating unsimilarity distance matrix for clustering
            %distance = zeros (R*C,R*C); 
            %%load(distance_filename,'distance'); % load distance from file
    else
        % creating unsimilarity distance matrix for clustering
        distance = zeros (R*C,R*C); 

        % calculate the distance from each pixel (i,j) from all other pixels in the image
        % using dept , norm_u_coef ,  ??????
        % iref and jref is the pixel which is going to be compared with all other pixels. 
        % icomp and jcomp is the pixel which we are comparing the reference with

        % calculating the depth distances outside the main loop
        dept_distance = zeros (R,R);
        for r1=1:R
            for r2=1:R
                if (r1 ~= r2)
                    if (r1<r2)
                        dept_distance (r1,r2) = (norm_depth(r1,1) - norm_depth(r2,1))^2 ;
                    else
                        dept_distance (r1,r2) = dept_distance (r2,r1) ;
                    end
                end
            end
        end

        % main loop for calculating distance between points
        myj = 0 ;
        tic; %start timing
        for jref = 1:C                 
                for iref = 1:R   
                    temp2 = norm_u_coef(iref,jref);           
                    myj = myj + 1 ; %(ref_col*(C-1)+ref_row)
                    myi = 0 ;
                    for jcomp = 1:C         
                            for icomp = 1:R  
                                myi = myi+1; %(comp_col*(C-1)+comp_row)
                                if (myi < myj) % upper matrix
                                    temp3 = dept_distance (icomp,iref) ; % calculating depth distances
                                    temp4 = (temp2 - norm_u_coef(icomp,jcomp))^2 ; % calculating norm_u_coef distances
                                    temp5 = sqrt (temp3+temp4) ;              
                                    distance ( myi , myj  ) =  temp5 ; 
                                    distance ( myj , myi  ) =  temp5 ;
                                else
                                    break;
                                end
                            end
                            if (myi >= myj) % we dont calculate the lower part of matrix
                                break;
                            end
                    end 
                end     
        end
        distance_timer = toc
        save(distance_filename,'distance'); 

    end % calculate distance

end

