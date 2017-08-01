%Elaheh Rashedi

function [ Intensity ] = logOCT( Intensity )

% after we do the filtering on image, we bring it back to OCT image
Intensity = 10 .* log10(Intensity) ;

end

