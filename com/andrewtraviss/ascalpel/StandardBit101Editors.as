/*
Copyright (C) 2011 by Andrew Traviss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*/
package com.andrewtraviss.ascalpel
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Knob;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Slider;
	import com.bit101.components.TextArea;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StandardBit101Editors
	{
		public static function install():void
		{
			AScalpel.instance.registerEditorClass(com.bit101.components.InputText, "text", Component.DRAW, Event.CHANGE);
			AScalpel.instance.registerEditorClass(com.bit101.components.NumericStepper, "value", Component.DRAW, Event.CHANGE);
			AScalpel.instance.registerEditorClass(com.bit101.components.ColorChooser, "value", Component.DRAW, Event.CHANGE);
			AScalpel.instance.registerEditorClass(com.bit101.components.CheckBox, "selected", Component.DRAW, MouseEvent.CLICK);
			AScalpel.instance.registerEditorClass(com.bit101.components.Knob, "value", Component.DRAW, Event.CHANGE);
			AScalpel.instance.registerEditorClass(com.bit101.components.Slider, "value", Component.DRAW, Event.CHANGE);
			AScalpel.instance.registerEditorClass(com.bit101.components.TextArea, "text", Component.DRAW, Event.CHANGE);
			
			AScalpel.instance.setDefaultEditorClassForType(com.bit101.components.InputText, String);
			AScalpel.instance.setDefaultEditorClassForType(com.bit101.components.InputText, Number, {restrict:"0-9.\\-"});
			AScalpel.instance.setDefaultEditorClassForType(com.bit101.components.InputText, int, {restrict:"0-9\\-"});
			AScalpel.instance.setDefaultEditorClassForType(com.bit101.components.InputText, uint, {restrict:"0-9"});
			AScalpel.instance.setDefaultEditorClassForType(com.bit101.components.CheckBox, Boolean);
		}
	}
}