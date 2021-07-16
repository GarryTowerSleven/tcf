module("fft", package.seeall )

BANDS = 2048

function GetAverage( fftdata, istart, iend )

	if not fftdata then return end

	istart = math.Round( math.Clamp( istart, 1, BANDS ) )
	iend = math.Round( math.Clamp( iend, 1, BANDS ) )

	local n = 0
	for i = istart, iend do
		n = n + fftdata[i]
	end

	local div = ( iend - istart )

	return div == 0 && 0 || ( n / div )

end

function GetBass( fftdata )
	return GetAverage( fftdata, 1, 15 )
end