package com.andrewtraviss.ascalpel
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class AScalpel
	{
		public static function get instance():AScalpel
		{
			if(!_instance)
			{
				_instance = new AScalpel();
			}
			return _instance;
		}
		
		public function AScalpel()
		{
			createMainUI();
			_activeEditors = new Dictionary();
		}
		
		public function registerEditorClass(in_editorClass:Class, in_valueName:String, in_initEvent:String, in_changeEvent:String):void
		{
			var name:String = describeType(in_editorClass).@name;
			name = name.split("::").join(".");
			PropertyEditorFactory.instance.registerEditorClass(name, in_valueName, in_initEvent, in_changeEvent);
		}
		
		public function setDefaultEditorClassForType(in_editorClass:String, in_type:Class, in_editorProperties:Object=null):void
		{
			PropertyEditorFactory.instance.setDefaultEditorClassForType(in_editorClass, in_type);
		}
		
		public function addObject(in_object:*):void
		{
			if(_objectSelecter.items.length == 0)
			{
				_mainWindow.visible = true;
			}
			_objectSelecter.addItem(in_object);
		}
		
		public function removeObject(in_object:*):void
		{
			_objectSelecter.removeItem(in_object);
			if(_activeEditors[in_object])
			{
				removeEditor(_activeEditors[in_object]);
			}
		}
		
		public function open(in_object:*):void
		{
			openEditorFor(in_object);
		}
		
		public function removeEditor(in_editor:LiveEditor):void
		{
			_ui.removeChild(in_editor.window);
			delete(_activeEditors[in_editor.value]);
		}
		
		private function createMainUI():void
		{
			_ui = new Sprite();
			_mainWindow = new Window(_ui, 0, 0, MAIN_TITLE);
			_mainWindow.width = 340;
			_mainWindow.visible = false;
			_objectSelecter = new ComboBox(_mainWindow, 0, 0, COMBO_DEFAULT);
			_objectSelecter.width = 300;
			_objectSelecter.addEventListener(Event.SELECT, handleObjectSelected);
		}
		
		private function handleObjectSelected(in_event:Event):void
		{
			openEditorFor(_objectSelecter.selectedItem);
		}
		
		private function openEditorFor(in_object:*):void
		{
			if(_activeEditors[in_object])
			{
				bringEditorToFrontFor(in_object);
				return;
			}
			createNewEditorFor(in_object);
		}
		
		private function bringEditorToFrontFor(in_object:*):void
		{
			var editor:LiveEditor = _activeEditors[in_object];
			_ui.addChild(editor.window);
		}
		
		private function createNewEditorFor(in_object:*):void
		{
			var windowTitle:String = editorTitleFrom(in_object);
			var editorWindow:Window = new Window(_ui, 0, 0, windowTitle);
			var editor:LiveEditor = new LiveEditor();
			editor.window = editorWindow;
			editorWindow.addChild(editor.display);
			editor.value = in_object;
			_activeEditors[in_object] = editor;
		}
		
		private function editorTitleFrom(in_object:*):String
		{
			return "Editing - " + in_object.toString();
		}
		
		public function get showMainWindow():Boolean
		{
			return _mainWindow.visible;
		}
		public function set showMainWindow(in_value:Boolean):void
		{
			_mainWindow.visible = in_value;
		}
		
		public function get display():Sprite
		{
			return _ui;
		}
		
		private var _mainWindow:Window;
		private var _objectSelecter:ComboBox;
		private var _activeEditors:Dictionary;
		private var _ui:Sprite;
		
		private static var _instance:AScalpel;
		
		private static const MAIN_TITLE:String = "AScalpel Object Selector";
		private static const COMBO_DEFAULT:String = "<Select an object>";
	}
}