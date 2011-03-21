function [resp, mcIndex] = teststimrec(stim_lr, inpts, indev, outdev, zdev)
%------------------------------------------------------------------------
% [resp, index] = teststimrec(stim_lr, inpts, zdev, indev, outdev)
%------------------------------------------------------------------------
%
% plays stim_lr out from sound card, fakes input spike data on 
%
%------------------------------------------------------------------------
% Input Arguments:
%	stim_lr		2XN sound output
%	inpts			# of input points
%	indev			tdt input device
%	outdev		tdt output device
%	zdev			TDT zbus
%
% Output Arguments:
%	resp			(1 X indev.nChannels*inpts)
%	mcIndex		# points
%------------------------------------------------------------------------
% See Also: headphonestim_medusarec, headphonecal_io
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 28 January, 2009
%
% Revisions:
%	5 February, 2009
% 		- added some tic/toc pairs to measure execution times at 
% 			key points in function
% 	8 March, 2009
% 		- removed tics and tocs
% 	9 March, 2009
% 		- added documentation
%		- changed input argument order to be consistent with other HPSearch
%			functions
%	3 September, 2009
%		-	removed invoke calls
% 		-	used newly implemented RPwriteV and RPreadV functions to write
% 			and read vector data to/from buffers
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

% sampling rate for sound card
Fs = 44100;

% input channels to fake
NCHANNELS = 4;

% expected output sampling rate
Fs_out = outdev.Fs;

% expected input sampling rate
Fs_in = indev.Fs;

% resample stimulus
tmpl = resample(stim_lr(1, :), Fs, Fs_out);
tmpr = resample(stim_lr(2, :), Fs, Fs_out);
stim = [tmpl; tmpr];

stimlen = length(stim);

% play sound
soundsc(stim, Fs);

resp_nompx = zeros(1, inpts);

if inpts > length(stim_lr)
	resp_nompx(1:length(stim_lr)) = 0.5 * sum(stim_lr);
else
	resp_nompx = 0.5 * sum(stim_lr(1:inpts));
end

resp = zeros(1, inpts * NCHANNELS);
for n = 1:inpts
	for m = n:n+NCHANNELS
		resp(1, m) = resp_nompx(n);
	end
end
mcIndex = length(resp);
