/**
 * Created by Anton Nefjodov on 26.01.2016.
 */
package com.crazyfm.core.mvc
{
	import com.crazyfm.core.common.Enum;
	import com.crazyfm.core.mvc.event.ISignalEvent;
	import com.crazyfm.core.mvc.model.Context;
	import com.crazyfm.core.mvc.model.Model;
	import com.crazyfm.core.mvc.model.ModelContainer;

	import flexunit.framework.Assert;

	import testObject.MyCoolEnum;

	public class BubblingEventTest
	{
		private var m1:Model;
		private var c1:Context;
		private var c2:Context;
		private var c3:Context;
		private var c4:Context;
		private var mc1:ModelContainer;
		private var mc2:ModelContainer;
		private var mc3:ModelContainer;
		private var mc4:ModelContainer;

		/**
		 * 			c1
		 * 			|
		 * 		 /	|  \
		 * 		c2	c3	c4
		 * 		|	|	|
		 * 		mc1	mc3	mc4
		 * 		|
		 * 		mc2
		 * 		|
		 * 		m1
		 */

		[Before]
		public function setUp():void
		{
			c1 = new Context();
			c2 = new Context();
			c3 = new Context();
			c4 = new Context();
			mc1 = new ModelContainer();
			mc2 = new ModelContainer();
			mc3 = new ModelContainer();
			mc4 = new ModelContainer();
			m1 = new Model();

			mc2.addModel(m1);
			mc1.addModel(mc2);
			c4.addModel(mc4);
			c3.addModel(mc3);
			c2.addModel(mc1);
			c1.addModel(c2);
			c1.addModel(c3);
			c1.addModel(c4);
		}

		[Test]
		public function testBubblingFromBottomToTop():void
		{
			var bubbledEventType:Enum;

			var successFunc:Function = function (event:ISignalEvent):Boolean
			{
				//event came from bottom to top
				bubbledEventType = event.type;
				return true;
			};

			//top element
			c1.addSignalListener(MyCoolEnum.PREVED, successFunc);

			//bottom element
			m1.dispatchSignal(MyCoolEnum.PREVED, {name: "Anton"});

			Assert.assertEquals(bubbledEventType, MyCoolEnum.PREVED);

			bubbledEventType = null;

			//bottom element
			m1.dispatchSignal(MyCoolEnum.PREVED, {name: "Anton"});

			Assert.assertEquals(bubbledEventType, MyCoolEnum.PREVED);
		}

		[Test]
		public function testHierarchy():void
		{
			Assert.assertTrue(c3.parent == c1);
			Assert.assertTrue(mc3.parent == c3);
			Assert.assertTrue(mc4.parent == c4);
			Assert.assertTrue(m1.parent == mc2);
			Assert.assertTrue(m1.parent != mc1);
			Assert.assertTrue(mc2.parent == mc1);
			Assert.assertTrue(mc2.parent != c2);
			Assert.assertTrue(m1.parent != c1);
		}

		[After]
		public function tearDown():void
		{
			c1.dispose();
		}
	}
}
