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
			
			AScalpel.instance.setDefaultEditorClassForType("com.bit101.components.InputText", String);
			AScalpel.instance.setDefaultEditorClassForType("com.bit101.components.InputText", Number, {restrict:"0-9.\\-"});
			AScalpel.instance.setDefaultEditorClassForType("com.bit101.components.InputText", int, {restrict:"0-9\\-"});
			AScalpel.instance.setDefaultEditorClassForType("com.bit101.components.InputText", uint, {restrict:"0-9"});
			AScalpel.instance.setDefaultEditorClassForType("com.bit101.components.CheckBox", Boolean);
		}
	}
}