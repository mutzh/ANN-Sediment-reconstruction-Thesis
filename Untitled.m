no_design_possibilites=9;
design_space=zeros(no_design_possibilites,2);
place=1;
for e=1:2:5
    for f=1:2:5
        design=[e,f];
        design_space(place,:)=design;
        
        place=place+1;
    end
end