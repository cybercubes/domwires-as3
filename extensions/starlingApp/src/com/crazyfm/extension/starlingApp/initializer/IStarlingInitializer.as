/**
 * Created by Anton Nefjodov on 16.06.2016.
 */
package com.crazyfm.extension.starlingApp.initializer
{
	import com.crazyfm.core.mvc.message.IMessageDispatcher;

	import starling.core.Starling;

	/**
	 * Object that configures and launches new Starling instance.
	 * Dispatches signals:
	 * StarlingInitializerMessage.STARLING_INITIALIZED
	 */

	/**
	 * Default implementation.
	 */
	StarlingInitializer;
	public interface IStarlingInitializer extends IMessageDispatcher
	{
		/**
		 * Returns created Starling instance.
		 */
		function get starling():Starling;
	}
}