/**
 * Created by Anton Nefjodov on 26.05.2016.
 */
package com.crazyfm.core.mvc.context
{
	import avmplus.getQualifiedClassName;

	import com.crazyfm.core.common.Enum;
	import com.crazyfm.core.factory.IAppFactory;
	import com.crazyfm.core.mvc.command.*;
	import com.crazyfm.core.mvc.message.IMessage;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * Maps specific messages to <code>ICommand</code>.
	 */
	public class CommandMapper implements ICommandMapper
	{
		/**
		 * @private
		 */
		[Autowired]
		public var factory:IAppFactory;

		private var commandMap:Dictionary/*Enum, Vector.<Class>*/ = new Dictionary();

		/**
		 * @inheritDoc
		 */
		public function CommandMapper()
		{
			super();
		}

		/**
		 * @private
		 */
		[PostConstruct]
		public function init():void
		{
			factory.mapToValue(ICommandMapper, this);
		}

		/**
		 * @inheritDoc
		 */
		public function map(messageType:Enum, commandClass:Class):ICommandMapper
		{
			if (!commandMap[messageType])
			{
				commandMap[messageType] = new <Class>[commandClass];
			}else
			if (commandMap[messageType].indexOf(commandClass) == -1){
				commandMap[messageType].push(commandClass);
			}

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(messageType:Enum, commandClass:Class):ICommandMapper
		{
			if (commandMap[messageType])
			{
				var index:int = commandMap[messageType].indexOf(commandClass);
				if (index != -1)
				{
					commandMap[messageType].removeAt(index);

					if (commandMap[messageType].length == 0)
					{
						commandMap[messageType] = null;

						delete commandMap[messageType];
					}
				}
			}

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():ICommandMapper
		{
			commandMap = new Dictionary();

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function tryToExecuteCommand(message:IMessage):void
		{
			var messageType:Enum = message.type;
			var mappedToMessageCommands:Vector.<Class> = commandMap[messageType];
			if (mappedToMessageCommands != null)
			{
				for each (var commandClass:Class in mappedToMessageCommands)
				{
					executeCommand(commandClass);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function executeCommand(commandClass:Class, params:Array = null):void
		{
			var command:ICommand = factory.getSingleton(commandClass) as ICommand;

			mapParams(params);

			factory.injectDependencies(commandClass, command);

			mapParams(params, false);

			command.execute();
			//TODO: async command
			command.retain();
		}

		private function mapParams(params:Array, map:Boolean = true):void
		{
			if (params)
			{
				for each (var param:* in params)
				{
					if (map)
					{
						factory.mapToValue(getDefinitionByName(getQualifiedClassName(param)) as Class, param);
					}else
					{
						factory.unmap(getDefinitionByName(getQualifiedClassName(param)) as Class);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function unmapAll(messageType:Enum):ICommandMapper
		{
			if (commandMap[messageType])
			{
				commandMap[messageType] = null;

				delete commandMap[messageType];
			}

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function hasMapping(messageType:Enum):Boolean
		{
			return commandMap[messageType] != null;
		}
	}
}
