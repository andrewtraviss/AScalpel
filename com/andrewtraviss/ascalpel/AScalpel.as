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
	import com.bit101.components.ComboBox;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class AScalpel
	{
		/**
		 * 
		 */
		public static function get instance():AScalpel
		{
			if(!_instance)
			{
				_instance = new AScalpel();
			}
			return _instance;
		}
		
		/**
		 * 
		 */
		public function AScalpel()
		{
			createMainUI();
			_activeEditorsByObject = new Dictionary();
		}
		
		/**
		 * Registers an editor class for use by AScalpel.
		 * 
		 * @param in_editorClass	The Class for the editor.
		 * @param in_valueName		The name of the property on the editor which is used to get and set its current value.
		 * @param in_initEvent		The event which the editor dispatches when its user interface has fully initialized.
		 * @param in_changeEvent	The event which the editor dispatches when its value changes.
		 */
		public function registerEditorClass(in_editorClass:Class, in_valueName:String, in_initEvent:String, in_changeEvent:String):void
		{
			var name:String = getClassNameWithPackage(in_editorClass);
			PropertyEditorFactory.instance.registerEditorClass(name, in_valueName, in_initEvent, in_changeEvent);
		}
		
		/**
		 * Sets the default editor class to use for a particular data type.
		 * 
		 * @param in_editorClass		The Class to use as an editor for this type. Should be registered using registerEditorClass, but it is not mandatory.
		 * @param in_type				The Class of the data type.
		 * @param in_defaultProperties	The default properties to apply to the editor when it is created.
		 */
		public function setDefaultEditorClassForType(in_editorClass:Class, in_type:Class, in_defaultProperties:Object=null):void
		{
			var name:String = getClassNameWithPackage(in_editorClass);
			PropertyEditorFactory.instance.setDefaultEditorClassForType(name, in_type, in_defaultProperties);
		}
		
		/**
		 * Adds an object to the editor to be selected via the main editor window combo box.
		 * 
		 * @param in_object			The object to add.
		 */
		public function addObject(in_object:*):void
		{
			if(_objectSelecter.items.length == 0)
			{
				_mainWindow.visible = true;
			}
			_objectSelecter.addItem(in_object);
		}
		
		/**
		 * Removes an object from the editor.
		 * 
		 * @param in_object			The object to remove.
		 */
		public function removeObject(in_object:*):void
		{
			_objectSelecter.removeItem(in_object);
			if(_activeEditorsByObject[in_object])
			{
				removeEditor(_activeEditorsByObject[in_object]);
			}
		}
		
		/**
		 * Opens an editor window for an object without adding it to the main editor window combo box.
		 * 
		 * @param in_object			The object to open an editor for. If an editor is already open for this object, it will be reused.
		 */
		public function open(in_object:*):void
		{
			openEditorFor(in_object);
		}
		
		/**
		 * @private
		 */
		public function removeEditor(in_editor:LiveEditor):void
		{
			_ui.removeChild(in_editor.window);
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
		
		private function getClassNameWithPackage(in_object:*):String
		{
			var reflection:XML = describeType(in_object);
			var name:String = reflection.@name;
			name = name.split("::").join(".");
			return name;
		}
		
		private function handleObjectSelected(in_event:Event):void
		{
			openEditorFor(_objectSelecter.selectedItem);
		}
		
		private function openEditorFor(in_object:*):void
		{
			var activeEditor:LiveEditor = activeEditorFor(in_object);
			if(activeEditor)
			{
				bringEditorToFrontFor(in_object);
				return;
			}
			createNewEditorFor(in_object);
		}
		
		private function bringEditorToFrontFor(in_object:*):void
		{
			var editor:LiveEditor = activeEditorFor(in_object);
			editor.value = in_object;
			_ui.addChild(editor.window);
		}
		
		private function activeEditorFor(in_object:*):LiveEditor
		{
			if(_activeEditorsByObject[in_object])
			{
				return _activeEditorsByObject[in_object];
			}
			if(hasAValidName(in_object) && _activeEditorsByInstanceName[in_object.name])
			{
				return _activeEditorsByInstanceName[in_object.name];
			}
			
			return null;
		}
		
		private function createNewEditorFor(in_object:*):void
		{
			var windowTitle:String = editorTitleFrom(in_object);
			var editorWindow:Window = new Window(_ui, 0, 0, windowTitle);
			var editor:LiveEditor = new LiveEditor();
			editor.window = editorWindow;
			editorWindow.addChild(editor.display);
			editor.value = in_object;
			_activeEditorsByObject[in_object] = editor;
			if(hasAValidName(in_object))
			{
				_activeEditorsByInstanceName[in_object.name] = editor
			}
		}
		
		private function editorTitleFrom(in_object:*):String
		{
			return "Editing - " + in_object.toString();
		}
		
		private function hasAValidName(in_object:*):Boolean
		{
			if(!in_object.hasOwnProperty("name"))
			{
				return false;
			}
			if(!in_object.name)
			{
				return false;
			}
			if(in_object.name =="")
			{
				return false;
			}
			return true
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
		private var _activeEditorsByObject:Dictionary;
		private var _activeEditorsByInstanceName:Object = {};
		private var _ui:Sprite;
		
		private static var _instance:AScalpel;
		
		private static const MAIN_TITLE:String = "AScalpel Object Selector";
		private static const COMBO_DEFAULT:String = "<Select an object>";
	}
}