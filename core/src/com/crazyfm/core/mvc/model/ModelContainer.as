/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.crazyfm.core.mvc.model
{
	import com.crazyfm.core.common.Enum;
	import com.crazyfm.core.mvc.hierarchy.HierarchyObjectContainer;
	import com.crazyfm.core.mvc.hierarchy.ns_hierarchy;

	use namespace ns_hierarchy;

	/**
	 * Extends IModel and is able to add or remove other IModel objects (can be parent of them). Also receives all
	 * signals from children, sub-children and so on.
	 */
	public class ModelContainer extends HierarchyObjectContainer implements IModelContainer
	{
		public function ModelContainer()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function addModel(model:IModel):IModelContainer
		{
			add(model);

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function removeModel(model:IModel, dispose:Boolean = false):IModelContainer
		{
			remove(model, dispose);

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllModels(dispose:Boolean = false):IModelContainer
		{
			removeAll(dispose);

			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function get numModels():int
		{
			return _childrenList != null ? _childrenList.length : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function containsModel(model:IModel):Boolean
		{
			return _childrenList.indexOf(model) != -1;
		}

		/**
		 * @inheritDoc
		 */
		public function get modelList():Array
		{
			//better to return copy, but in sake of performance, we do that way.
			return _childrenList;
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchSignalToModels(type:Enum, data:Object = null):void
		{
			dispatchSignalToChildren(type, data);
		}
	}
}
