package com.andrewtraviss.ascalpel
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class PropertyEditor
	{
		public function useView(in_view:*):void
		{
			_editor = in_view;
		}
		
		public function useObjectChangeEvent(in_eventName:String):void
		{
			if(_object)
			{
				_object.addEventListener(in_eventName, handleObjectChanged);
			}
		}
		
		public function useCommitControl(in_control:IEventDispatcher):void
		{
			if(_editorDispatcher)
			{
				clearEditorListener();
			}
			_editorDispatcher = in_control;
			if(_editorChangeEvent)
			{
				createEditorListener();
			}
		}
		
		public function useCommitEvent(in_value:String):void
		{
			if(_editorChangeEvent)
			{
				clearEditorListener();
			}
			_editorChangeEvent = in_value;
			if(_editorDispatcher)
			{
				createEditorListener();
			}
		}
		
		public function useEditorProperty(in_value:String):void
		{
			_editorProperty = in_value;
		}
		
		public function targetProperty(in_object:*, in_property:String):void
		{
			_object = in_object;
			_property = in_property;
			refresh();
		}
		
		public function refresh():void
		{
			_editor[_editorProperty] = _object[_property];
		}
		
		private function handleObjectChanged(in_event:Event):void
		{
			updateView();
		}
		
		private function handleEditorChanged(in_event:Event):void
		{
			updateObject();
		}
		
		private function updateView():void
		{
			_editor[_editorProperty] = _object[_property];
		}
		
		private function updateObject():void
		{
			_object[_property] = _editor[_editorProperty];
		}
		
		private function createEditorListener():void
		{
			_editorDispatcher.addEventListener(_editorChangeEvent, handleEditorChanged);
		}
		
		private function clearEditorListener():void
		{
			_editorDispatcher.removeEventListener(_editorChangeEvent, handleEditorChanged);
		}
		
		public function get currentValue():*
		{
			return _editor[_editorProperty];
		}
		public function set currentValue(in_value:*):void
		{
			_editor[_editorProperty] = in_value;
		}
		
		public function get view():DisplayObject
		{
			return _editor;
		}
		
		public var explicitCommit:Boolean;
		
		private var _object:*;
		private var _property:String;
		
		private var _editor:*;
		private var _editorProperty:String;
		private var _editorChangeEvent:String;
		private var _editorDispatcher:IEventDispatcher;
	}
}