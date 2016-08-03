/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.crazyfm.core.mvc.context
{
	import com.crazyfm.core.mvc.message.IMessage;
	import com.crazyfm.core.mvc.model.IModelContainer;
	import com.crazyfm.core.mvc.view.IViewContainer;

	/**
	 * Context contains models, views and services. Also implements <code>ICommandMapper</code>. You can map specific messages, that
	 * came out
	 * from hierarchy, to <code>ICommand</code>s.
	 */
	public interface IContext extends IModelContainer, IViewContainer, ICommandMapper
	{
		/**
		 * Dispatches messages to views.
		 * @param message
		 */
		function dispatchMessageToViews(message:IMessage):void;

		/**
		 * Dispatches message to models.
		 * @param message
		 */
		function dispatchMessageToModels(message:IMessage):void;
	}
}