function [back_proj]= inverseradongui(image, number_of_projections, beam_number, f, handles)

%image input
%number of projections input
%beam_number input
%filter selection input

%back_proj output

% number_of_projections = 100;
% beam_number = 100;
% load('square.mat')
% image = square;
% 
%  
%find the size of image
image_size = size(image , 1);
xcoor = -image_size/2:image_size/2; %grid between -M/2 and M/2
ycoor = -image_size/2:image_size/2; 
 
%evenly distributed angles
angle = linspace(0, 180 - (180/number_of_projections), number_of_projections ); 

T = linspace( (-image_size*sqrt(2))/2 , (image_size*sqrt(2))/2 , beam_number ) ; %t vektörü
 
projection = zeros(number_of_projections , beam_number); 
%total projection data that we will obtain in the end
 
back_proj=zeros(image_size,image_size);


%for inverse crime uncomment
%R = radon(image, angle)'; 

for i=1:number_of_projections %for each angle
for j=1:beam_number  %for each beam 
    
    %found x points from y values
    known_x(2,:) = -image_size/2:image_size/2;    %the grid's known x values
    
    %found y points from x values
    known_y(1,:) = -image_size/2:image_size/2;    %the grid's known y values
    
     %find the unknown coordinates from line equation
     for c=1:1:(image_size+1)
        known_x(1,c) = (T(j) - ycoor(c) * sind( angle(i) ) ) / cosd(angle(i)) ;
        known_y(2,c) = (T(j) - xcoor(c) * cosd(angle(i)) ) / sind(angle(i));
     end
        
     uniquelistx = unique(known_x','rows')'; %list the unique coordinates
     uniquelisty = unique(known_y','rows')';
     
     concat = [uniquelistx uniquelisty]; %add the unique lists one after another
 
     for temprw = 1:2
         clmn=1;
         conc = concat';
         sizec = size(conc);
         for temp = 1:sizec
             if (concat(temprw,clmn) > -image_size/2 && concat(temprw,clmn) < image_size/2)
                clmn = clmn + 1; %pass to next column
             else
                concat (:,clmn) = [];  %delete column if out of bound
             end
         end
     end
     
    mylist = sortrows(concat'); %adjust the order in the list
    listsize = size(mylist,1);
    
    hipot1 = zeros(listsize-1);
    offsetx1 = zeros(listsize-1); 
    offsety1 = zeros(listsize-1);

    
 for point=1:(listsize-1) %for each found point
     
     foundx = ( mylist(point+1,1) + mylist(point,1) ) / 2 ;
     offsetx = image_size/2 + ceil(foundx); 
 
     foundy = ( mylist(point+1,2) + mylist(point,2) ) / 2 ;
     offsety = image_size/2 - floor(foundy);
 
     hipot = sqrt((mylist(point+1,1)-mylist(point,1)) * (mylist(point+1,1)-mylist(point,1)) + (mylist(point+1,2) - mylist(point,2)) * (mylist(point+1,2)-mylist(point,2)) );

     hipot1(point) = hipot;
     offsetx1(point) = offsetx;
     offsety1(point) = offsety;
    
     %the pixel value in the corresponding point
     pixel_value = image(offsetx,offsety);
     %sum up the product of the obtained distances and pixelvalues
     projection(i,j) = projection(i,j) + hipot*pixel_value; 
    
 end
     bhipot{i,j}= hipot1;        %saving for obtaining filtered backprojection
     boffsetx{i,j}= offsetx1;
     boffsety{i,j}= offsety1;
     length{i,j} = size(boffsetx{i,j});
                                        
end
end

fft_proj = (fft2(projection));

ramp = [0 1:((beam_number-1)/2) ((beam_number-1)/2 + 0.5):-1:1];

for n=1:beam_number
hann(n) = 0.5*( 1-cos( 2*pi*n/(beam_number-1) ) );
hamming(n) = 0.54-0.46*( cos(2*pi*n/(beam_number-1) ) );
end

unfiltered = ones(beam_number);

hamming = hamming.*( ramp);



%filter selection: 
% 1 = ramp(Ram Lak)
% 2 = hann
% 3 = hamming
% 4 = unfiltered


%f = 1; %select manually

switch f
    case 1
        filter = ramp;
    case 2
        filter = hann;
    case 3
        filter = hamming;
    case 4
        filter = unfiltered;
    otherwise
        warning('Valid values are 1,2,3,4');
end
 


for i=1:number_of_projections
for deg=1:beam_number
    filtered_proj(i,deg) = filter(deg).*fft_proj(i,deg);
end
end

backed_proj = real(ifft2(filtered_proj));

back_proj=zeros(image_size,image_size);  %reconstruct filtered image
for i=1:number_of_projections
    for j = 1:beam_number
        for cor=1:length{i,j}
            back_proj(boffsetx{i,j}(cor),boffsety{i,j}(cor))=back_proj(boffsetx{i,j}(cor),boffsety{i,j}(cor))+ backed_proj(i,j)*bhipot{i,j}(cor);
        end
    end  
end


% imagesc(back_proj)
% colormap(gray)
% colorbar

end