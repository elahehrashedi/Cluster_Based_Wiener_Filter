%Elaheh Rashedi


function [ norm_u_coef ] = Attenuation2 ( R , C , norm_Intensity )

    % this is second method to calculate attenuation
    % which uses the polyfit(x,y,n) function for 20 points 
    
    % the depth of intensity calculation
    depth = 10 ;

    % attenuation coefficient "u_coef"
    u_coef = zeros (R,C);
    x = linspace(0,1,depth);
    for j=1:C-1
        for i=1:R  
            endpoint = j + depth - 1 ;
            if (endpoint > C ) 
                endpoint=C; 
            end
            %display (j);
            slope = polyfit(x(1,1:endpoint - j+1),norm_Intensity(i,j:endpoint),1) ;
            u_coef (i,j) = slope (1) ;
        end  
    end 
    

    u_coef(isnan(u_coef)) = 0 ; %delete NAN values
    u_coef(isinf(u_coef)) = 1 ; %delete NAN values

    %normalize attenuation coefficient "u_coef" on each A-scan, means on each column
    norm_u_coef = MatrixNorm (u_coef);
    %figure,imshow (norm_u_coef,[]); title('\color{magenta}normalized u coefficient');
end

