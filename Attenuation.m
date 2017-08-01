%Elaheh Rashedi

function [ norm_u_coef ] = Attenuation ( R , C , norm_Intensity )

    % calculate sum of I for the last row
    sum_of_Intensity_in_col = zeros (R,C);

    % attenuation coefficient "u_coef"
    u_coef = zeros (R,C);

    %bottom to top
    for i = (R-1):-1:1 % skip the last row
                sum_of_Intensity_in_col(i,:) = sum_of_Intensity_in_col(i+1,:) + norm_Intensity (i+1,:) ;
                u_coef (i,:) = 1/2 * log ( 1+ norm_Intensity (i,:) ./ (sum_of_Intensity_in_col(i,:) )) ;

    end

    u_coef(isnan(u_coef)) = 0 ; %delete NAN values
    u_coef(isinf(u_coef)) = 1 ; %delete NAN values

    %normalize attenuation coefficient "u_coef" on each A-scan, means on each column
    norm_u_coef = MatrixNorm (u_coef);
    %figure,imshow (norm_u_coef,[]); title('\color{magenta}normalized u coefficient');
end

