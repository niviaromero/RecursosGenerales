package editor
{
import mx.utils.ObjectUtil;

public class ColorUtil
{
	public function ColorUtil()
	{
	}


	public static function validateHexColor(color:String):Boolean
	{
		return (/^#?([a-f]|[A-F]|[0-9]){1,6}?$/).test(color);
	}

	public static function getHexColorFromString(color:String):uint
	{
		return uint("0x" + color.substr(1));
	}

	public static function convertUintToHexColor(dec:uint):String
	{
		var digits:String = "0123456789ABCDEF";
		var hex:String = '';

		while (dec > 0)
		{
			var next:uint = dec & 0xF;
			dec >>= 4;
			hex = digits.charAt(next) + hex;
		}

		while (hex.length != 6)
		{
			hex = "0" + hex;
		}
		return "#" + hex;
	}

	public static function getCopyOfGradientWithColor(gradient:Object, color:uint):Object
	{
		var newGradient:Object = ObjectUtil.copy(gradient);

		newGradient.colors[newGradient.colors.length - 1] = color;
		for (var i:int = newGradient.colors.length - 2; i >= 0; i--)
		{
			newGradient.colors[i] = getCoperhensiveColor(gradient.colors[i + 1], gradient.colors[i], newGradient.colors[i + 1]);
		}
		return newGradient;
	}

	public static function getCoperhensiveColor(color1:uint, color2:uint, color3:uint):uint
	{

		var c1:Object = hexToRGB(color1);
		var c2:Object = hexToRGB(color2);
		var c3:Object = hexToRGB(color3);

		var c3hsv:Object = rgb2hsv(c3.r, c3.g, c3.b);
		var sat:Number = rgb2hsv(c2.r, c2.g, c2.b).s - rgb2hsv(c1.r, c1.g, c1.b).s;
		var vat:Number = rgb2hsv(c2.r, c2.g, c2.b).v - rgb2hsv(c1.r, c1.g, c1.b).v;
		var hat:Number = rgb2hsv(c2.r, c2.g, c2.b).h - rgb2hsv(c1.r, c1.g, c1.b).h;
		//trace(c3hsv.s, sat, rgb2hsv(c2.r, c2.g, c2.b).v, rgb2hsv(c1.r, c1.g, c1.b).v);
		var c4:Object = hsv2rgb(c3hsv.h + hat, c3hsv.s + sat, c3hsv.v + vat);
		var color4:uint = rgbToHex(c4.r, c4.g, c4.b);
		return color4;
	}


	public static function hsv2rgb(hue:Number, sat:Number, val:Number):Object
	{
		var red:Number, grn:Number, blu:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
		hue %= 360;
		if (val == 0)
		{
			return({r:0, g:0, b:0});
		}
		sat /= 100;
		val /= 100;
		hue /= 60;
		i = Math.floor(hue);
		f = hue - i;
		p = val * (1 - sat);
		q = val * (1 - (sat * f));
		t = val * (1 - (sat * (1 - f)));
		if (i == 0)
		{
			red = val;
			grn = t;
			blu = p;
		}
		else if (i == 1)
		{
			red = q;
			grn = val;
			blu = p;
		}
		else if (i == 2)
		{
			red = p;
			grn = val;
			blu = t;
		}
		else if (i == 3)
		{
			red = p;
			grn = q;
			blu = val;
		}
		else if (i == 4)
		{
			red = t;
			grn = p;
			blu = val;
		}
		else if (i == 5)
		{
			red = val;
			grn = p;
			blu = q;
		}
		red = Math.floor(red * 255);
		grn = Math.floor(grn * 255);
		blu = Math.floor(blu * 255);
		return ({r:red, g:grn, b:blu});
	}

	public static function rgb2hsv(red:Number, grn:Number, blu:Number):Object
	{
		var x:Number, val:Number, f:Number, i:Number, hue:Number, sat:Number;
		red /= 255;
		grn /= 255;
		blu /= 255;
		x = Math.min(Math.min(red, grn), blu);
		val = Math.max(Math.max(red, grn), blu);
		if (x == val)
		{
			return({h:0, s:0, v:val * 100});
		}
		f = (red == x) ? grn - blu : ((grn == x) ? blu - red : red - grn);
		i = (red == x) ? 3 : ((grn == x) ? 5 : 1);
		hue = Math.floor((i - f / (val - x)) * 60) % 360;
		sat = Math.floor(((val - x) / val) * 100);
		val = Math.floor(val * 100);
		return({h:hue, s:sat, v:val});
	}

	public static function rgbToHex(r:Number, g:Number, b:Number):Number
	{
		return r << 16 | g << 8 | b;
	}

	public static function hexToRGB(hex:Number):Object
	{
		var rgbObj:Object = {
			r: ((hex & 0xFF0000) >> 16),
			g: ((hex & 0x00FF00) >> 8),
			b: ((hex & 0x0000FF))
		};

		return rgbObj;
	}

	public static function transformColor(color:int, h:int, s:int, v:int):uint
	{
		var rgb:Object = ColorUtil.hexToRGB(color);
		var hsv:Object = ColorUtil.rgb2hsv(rgb.r, rgb.g, rgb.b);
		hsv.h = Number(hsv.h) + Number(h) * 3.6;
		hsv.h = normalizeRange(hsv.h, 0, 360);

		hsv.s = Number(hsv.s) + Number(s);
		hsv.s = normalizeRange(hsv.s, 0, 100);

		hsv.v = Number(hsv.v) + Number(v);
		hsv.v = normalizeRange(hsv.v, 0, 100);

		rgb = ColorUtil.hsv2rgb(hsv.h, hsv.s, hsv.v);
		return ColorUtil.rgbToHex(rgb.r, rgb.g, rgb.b)
	}

	private static function normalizeRange(value:Number, from:Number, to:Number):Number
	{
		//return value%to;
		if (value < from)
		{
			value += to;
		}
		else if (value > to)
		{
			value -= to;
		}
		return value;
	}
}
}