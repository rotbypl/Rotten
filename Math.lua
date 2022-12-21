Math = {
	Precision = 200
}

-- Functions
function Math.absolute (number: number)
	return if number < 0 then -number else number
end

function Math.clamp (number: number, range: NumberRange)
	if number < range.Min then
		return range.Min
	elseif number > range.Max then
		return range.Max
	else
		return number
	end
end

function Math.maximum (number: number, max: number)
	return if number > max then max else number
end

function Math.minimum (number: number, min: number)
	return if number < min then min else number
end

function Math.distance (first: number, second: number)
	return Math.absolute(first - second)
end

function Math.floor (number: number)
	return number - (number % 1)
end

function Math.ceiling (number: number)
	local floor = Math.floor(number)

	return if Math.distance(number, floor) > 0 then floor + 1 else number
end

function Math.round (number: number)
	local floor = Math.floor(number)

	return if Math.distance(number, floor) >= 0.5 then floor + 1 else floor
end

function Math.squareRoot (number: number)
	local guess = number

	for index = 1, Math.Precision, 1 do
		-- Newton's Method of Approximation
		guess = (guess - (guess^2 - number) / (2 * guess))
	end

	return if number < 0 then nil elseif number == 0 then 0 else guess
end

function Math.factorial (number: number)
	for index = number - 1, 1, -1 do
		number *= index
	end

	return number
end

function Math.sine (number: number, hyperbolic: boolean?)
	if hyperbolic then
		return math.sinh(number)
	end
	
	return math.sin(number)
end

function Math.cosine (number: number, hyperbolic: boolean?)
	if hyperbolic then
		return math.cosh(number)
	end
	
	return math.cos(number)
end

function Math.tangent (number: number, hyperbolic: boolean?)
	if hyperbolic then
		return math.tanh(number)
	end
	
	return math.tan(number)
end

function Math.cotangent (number: number, hyperbolic: boolean?)
	return Math.cosine(number, hyperbolic) / Math.sine(number, hyperbolic)
end

function Math.arcSine (number: number)
	return math.asin(number)
end

function Math.arcCosine (number: number)
	return math.acos(number)
end

function Math.arcTangent (number: number, hyperbolic)
	return math.atan(number)
end

function Math.logarithm (number: number, base: number?)
	return math.log(number)
end

function Math.exponential (number: number)
	return math.exp(number)
end

function Math.degrees (radians: number)
	return radians * (180 / Math.PI)
end

function Math.radians (degrees: number)
	return degrees * (Math.PI / 180)
end

function Math.sign (number: number)
	return if number > 0 then 1 elseif number < 0 then -1 else 0
end

function Math.percentage (whole: number, part: number)
	return (part / whole) * 100
end

function Math.precision (number: number, places: number)
	return Math.lower(Math.floor(Math.raise(number, places)), places)
end

function Math.raise (number: number, places: number)
	number = Math.absolute(Math.floor(number))

	return if places == 0 then number elseif places == 1 then number * 10 else number^places
end

function Math.lower (number: number, places: number)
	number = Math.absolute(Math.floor(number))

	return if places == 0 then number elseif places == 1 then number * 0.1 else number^(-places)
end

function Math.random (rangeOrRounded: NumberRange | boolean?, rounded: boolean?)
	local range = if typeof(rangeOrRounded) == 'NumberRange' then rangeOrRounded else NumberRange.new(0, 1)
	local random = range.Min + (math.random() * Math.distance(range.Min, range.Max))

	return if rangeOrRounded == true or rounded then Math.round(random) else random
end

function Math.noise (vector: Vector3)
	return math.noise(vector.X, vector.Y, vector.Z)
end

function Math.tail (number: number)
	return number - Math.floor(number)
end

-- Constants
Math.E = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166 -- Euler's Number
Math.PI = 3.141592653589793238462643383279502884197169399375105820974944 -- PI
Math.TAU = 2 * Math.PI -- 2 * PI
Math.PHI = 1.618033988749894848204586834365638117720309179805762862135 -- Golden Ratio

Math.INF = 2^1024 -- Highest storable number in Luau
Math.NAN = 0 / 0 -- Not a number

-- Shorthands
Math.abs = Math.absolute
Math.max = Math.maximum
Math.min = Math.minimum
Math.dist = Math.distance
Math.ceil = Math.ceiling
Math.sqrt = Math.squareRoot
Math.fact = Math.factorial
Math.sin = Math.sine
Math.asin = Math.arcSine
Math.cos = Math.cosine
Math.acos = Math.arcCosine
Math.tan = Math.tangent
Math.atan = Math.arcTangent
Math.cot = Math.cotangent
Math.log = Math.logarithm
Math.exp = Math.exponential
Math.deg = Math.degrees
Math.rad = Math.radians
Math.rand = Math.random

Math.sinh = function (number: number)
	return Math.sin(number, true)
end

Math.asinh = function (number: number)
	return Math.arcSine(number, true)
end

Math.cosh = function (number: number)
	return Math.cos(number, true)
end

Math.acosh = function (number: number)
	return Math.arcCosine(number, true)
end

Math.tanh = function (number: number)
	return Math.tan(number, true)
end

Math.atanh = function (number: number)
	return Math.arcTangent(number, true)
end

Math.coth = function (number: number)
	return Math.cotan(number, true)
end

Math.log10 = function (number: number)
	return Math.logarithm(number, 10)
end

Math.log2 = function (number: number)
	return Math.logarithm(number, 2)
end

return Math
