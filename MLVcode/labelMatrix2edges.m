function edges = labelMatrix2edges(L)
% edges = labelMatrix2edges(L)
% labelMatrix2edges extracts edges from a label matrix.
%
% Input:
%   L - Label matrix where each region has a unique integer label.
% Output:
%   edges - Binary image where 1s represent edges.

    % L is your label matrix
    [rows, cols] = size(L);
    edges = false(rows, cols);

    % Check internal pixels (avoid border issues)
    % Compare pixel with its top, bottom, left, and right neighbors
    edges(2:end-1,2:end-1) = (L(2:end-1,2:end-1) ~= L(1:end-2,2:end-1)) | ... % top
                             (L(2:end-1,2:end-1) ~= L(3:end,2:end-1))   | ... % bottom
                             (L(2:end-1,2:end-1) ~= L(2:end-1,1:end-2))   | ... % left
                             (L(2:end-1,2:end-1) ~= L(2:end-1,3:end));         % right

    % Optionally, you can also check the border pixels manually.
    % For example, you might set the border of the image to be edges:
    edges(1,:) = true;
    edges(end,:) = true;
    edges(:,1) = true;
    edges(:,end) = true;
end

