package com.andrewtraviss.ascalpel
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class PropertyEditorFactory
	{
		public static function get instance():PropertyEditorFactory
		{
			if(!_instance)
			{
				_instance = new PropertyEditorFactory();
			}
			return _instance;
		}
		
		public function PropertyEditorFactory()
		{
			_defaultEditorsForTypes = new Dictionary();
			_defaultPropertiesForTypes = new Dictionary();
		}
		
		public function registerEditorClass(in_editorClass:String, in_valueName:String, in_initEvent:String, in_commitEvent:String):void
		{
			_valueNamesForEditors[in_editorClass] = in_valueName;
			_commitEventsForEditors[in_editorClass] = in_commitEvent;
		}
		
		public function setDefaultEditorClassForType(in_editorClass:String, in_type:Class, in_properties:Object):void
		{
			_defaultEditorsForTypes[in_type] = in_editorClass;
			_defaultPropertiesForTypes[in_type] = in_properties;
		}
		
		public function fromXML(in_xml:XML):PropertyEditor
		{
			var editorClassName:String = getEditorClassNameFor(in_xml);
			var editorField:String = getValueFieldFor(editorClassName);
			var editorEvent:String = getCommitEventFor(editorClassName);
			var editorInstance:* = instanceFromClassName(editorClassName);
			
			var defaultEditorProperties:Object = getDefaultEditorPropertiesFor(in_xml);
			applyDefaultPropertiesToEditor(defaultEditorProperties, editorInstance);
			
			var potentialEditorProperties:Array = getUnreservedArgumentsFrom(in_xml);
			applyPropertiesFromXMLToEditor(potentialEditorProperties, editorInstance);
			
			var propertyEditor:PropertyEditor = new PropertyEditor();
			propertyEditor.useView(editorInstance);
			propertyEditor.useEditorProperty(editorField);
			
			
			var result:String = getArgumentValueFrom("explicitCommit", in_xml);
			if(result == "true")
			{
				propertyEditor.explicitCommit = true;
			}
			else
			{
				propertyEditor.useCommitControl(editorInstance);
				propertyEditor.useCommitEvent(editorEvent);
			}
			
			return propertyEditor;
		}
		
		private function getEditorClassNameFor(in_property:XML):String
		{
			var editorClassName:String = getArgumentValueFrom("editorClass", in_property);
			if(!editorClassName || editorClassName == "")
			{
				editorClassName = _defaultEditorsForTypes[getDefinitionByName(in_property.@type)];
			}
			return editorClassName;
		}
		
		private function getValueFieldFor(in_editor:String):String
		{
			if(_valueNamesForEditors[in_editor])
			{
				return _valueNamesForEditors[in_editor];
			}
			if(getImplicitValueFieldFor(in_editor))
			{
				return getImplicitValueFieldFor(in_editor);
			}
			throw(new Error("Custom editor did not have a data field specified and does not support any default data field names."));
		}
		
		private function getCommitEventFor(in_editor:String):String
		{
			if(_commitEventsForEditors[in_editor])
			{
				return _commitEventsForEditors[in_editor];
			}
			return Event.CHANGE;
		}
		
		private function instanceFromClassName(in_name:String):*
		{
			var classReference:Class = Class(getDefinitionByName(in_name));
			return new classReference();
		}
		
		private function applyDefaultPropertiesToEditor(in_properties:Object, in_editor:*):void
		{
			var value:String;
			for(var key:String in in_properties)
			{
				value = in_properties[key];
				if(in_editor.hasOwnProperty(key))
				{
					in_editor[key] = value;
				}
			}
		}
		
		private function applyPropertiesFromXMLToEditor(in_properties:Array, in_editor:*):void
		{
			var key:String;
			var value:String;
			for(var i:int=0; i<in_properties.length; i++)
			{
				key = in_properties[i].@key;
				value = in_properties[i].@value;
				if(in_editor.hasOwnProperty(key))
				{
					in_editor[key] = value;
				}
			}
		}
		
		private function getDefaultEditorPropertiesFor(in_property:XML):Object
		{
			return _defaultPropertiesForTypes[getDefinitionByName(in_property.@type)];
		}
		
		private function getUnreservedArgumentsFrom(in_property:XML):Array
		{
			var editableTag:XMLList = in_property.metadata.(@name=="Editable");
			var unreservedArguments:Array = [];
			var editableArguments:XMLList = editableTag..arg;
			for(var i:int=0; i<editableArguments.length(); i++)
			{
				if(RESERVED_PARAMETERS.indexOf(editableArguments[i].@key) == -1)
				{
					unreservedArguments[unreservedArguments.length] = editableArguments[i];
				}
			}
			return unreservedArguments;
		}
		
		private function getImplicitValueFieldFor(in_editor:*):String
		{
			for(var i:int=0; i<POSSIBLE_IMPLICIT_FIELDS.length; i++)
			{
				if(in_editor.hasOwnProperty(POSSIBLE_IMPLICIT_FIELDS[i]))
				{
					return POSSIBLE_IMPLICIT_FIELDS[i];
				}
			}
			return null
		}
		
		private function getArgumentValueFrom(in_argument:String, in_property:XML):String
		{
			var editableTag:XMLList = in_property.metadata.(@name=="Editable");
			var matches:XMLList = editableTag..arg.(@key==in_argument)
			if(matches.length()==0)
			{
				return null;
			}
			return matches.@value;
		}
		
		private var _commitEventsForEditors:Object = {};
		private var _valueNamesForEditors:Object = {};
		private var _defaultEditorsForTypes:Dictionary;
		private var _defaultPropertiesForTypes:Dictionary;
		
		private var RESERVED_PARAMETERS:Array = ["editorClass", "explicitCommit"];
		private var POSSIBLE_IMPLICIT_FIELDS:Array = ["value", "selectedValue", "text", "selectedItem"];
		private static var _instance:PropertyEditorFactory;
	}
}