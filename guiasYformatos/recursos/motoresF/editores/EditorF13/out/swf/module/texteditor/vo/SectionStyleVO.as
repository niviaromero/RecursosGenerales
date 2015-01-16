package module.texteditor.vo
{
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;

import flashx.textLayout.formats.TextDecoration;

import flashx.textLayout.formats.TextLayoutFormat;

public class SectionStyleVO
{
    public var name:String;
    public var size:int;
    public var font:String;
    public var bold:Boolean;
    public var italic:Boolean;
    public var underline:Boolean;

    public function SectionStyleVO(name:String, size:int, font:String, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false)
    {
        this.name = name;
        this.size = size;
        this.font = font;
        this.bold = bold;
        this.italic = italic;
        this.underline = underline;
    }

    public function comparesTo(style:TextLayoutFormat):Boolean
    {
        if (style.fontSize != size) return false;
        if (style.fontFamily != font) return false;
        if ((style.fontWeight == FontWeight.BOLD) != bold) return false;
        if ((style.fontStyle == FontPosture.ITALIC) != italic) return false;
        if ((style.textDecoration == TextDecoration.UNDERLINE) != underline) return false;
        return true;
    }
}
}