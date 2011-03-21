function status = RPwriteV(RPstruct, bufname, vectordata, bufoffset)
%--------------------------------------------------------------------------
% status = RPwriteV(RPstruct, bufname, vectordata, bufoffset)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Writes vector vectordata to buffer with tag bufname on device RPstruct
% bufoffset will write the data to the buffer starting at bufoffset. If
% not provided, default bufoffset == 0
%
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	bufname	tag name for buffer data from RP circuit
% 	vectordata	vector data to write to buffer (must be single precision)
% 
%	Optional Input:
% 		bufoffset		offset to start data values in buffer bufname
% 
% Output Arguments:
% 	status	
%
%------------------------------------------------------------------------
% See also: RPreadV
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%	Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 3 September, 2009
%
% Revisions:
%	15 Feb 2010 (SJS): Updated documentation
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are okay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3
	error([mfilename ': bad arguments'])
end
if nargin == 3
	bufoffset = 0;
else
	if bufoffset < 0
		warning([mfilename ': bufoffset must be >= 0!'])
		bufoffset = 0;
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write the buffer 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPstruct.C.WriteTagV(bufname, bufoffset, vectordata);

