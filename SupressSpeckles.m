%Elaheh Rashedi

function [ variance ] = SupressSpeckles ( R , C , N , M , Intensity , Threashold )


    %this method suppress the "mostly likely speckle" points 
    % so that before staring clustering and filtering, the speckle points
    % will be reduced
    
    % the method #3 is prefered to previous ones

    % R is number of rows of image (depth) 
    % C is number of columns of image 
    % N is the row size (depth) of window for filtering <R>
    % M is the column size of window for filtering <C>
    
    Supress_Intensity = Intensity ;
    %Supress_Intensity = zeros (R,C) ;
    %mean_mat = zeros (R,C);
    variance = zeros (R,C);
    speckles = 0 ;
    
    for j=1:C
        for i=1:R
            % calculate the window N*M around each pixel
            minM = j - (M-1)/2 ; if (minM<1) minM=1; end
            maxM = j + (M-1)/2 ; if (maxM>C) maxM=C; end
            minN = i - (N-1)/2 ; if (minN<1) minN=1; end
            maxN = i + (N-1)/2 ; if (maxN>R) maxN=R; end

            %mywindow = NaN (N*M,1,'double'); % maximum widow size
            mywindow = zeros (1,1);
            relative_window =  zeros (1,1); % a window which containd relative variance values
            k = 0 ; % 
            center = Intensity (i,j) ;

            for wj = minM : maxM
                for wi = minN : maxN
                    if ( wj ~= j || wi ~= i ) % exclude the center pixel
                        k = k + 1;
                        neighbor = Intensity (wi,wj);
                        if ((center + neighbor) ~= 0) 
                            relative_window(k) = abs (center - neighbor ) / ((center + neighbor)/2) ; % (a+b) / mean (a,b)
                        else
                            relative_window(k) = 0 ;
                        end
                        mywindow(k) = neighbor ;
                    end
                end
            end  
            mywindow(k+1) = center ; % add the value of the center point to vector
            variance (i,j) = var(relative_window); 
            if ( variance(i,j) > Threashold )
                
                mean_mat = mean (mywindow) ;
                speckles = speckles + 1 ;
                
                %replace the speckle with the mean
                Supress_Intensity (i,j) = mean_mat ;
            end
        end
    end

    variance = MatrixNorm (variance);
    disp(speckles);
    %Supress_Intensity2 = logOCT (Supress_Intensity) ; 
    figure, imshow (Supress_Intensity,[]) ; title('\color{magenta}Supress Intensity');
        
end

