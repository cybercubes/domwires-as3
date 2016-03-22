/**
 * Created by Anton Nefjodov on 21.03.2016.
 */
package com.crazyfm.extension.goSystem
{
	import com.crazyfm.extension.goSystem.mechanisms.EnterFrameMechanism;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class GOSystemTest
	{
		private var s:IGOSystem;

		[Before]
		public function setUp():void
		{
			s = new GOSystem()
					.setMechanism(new EnterFrameMechanism());
		}

		[After]
		public function tearDown():void
		{
			s.disposeWithAllChildren();
		}

		[Test]
		public function testNumGameObjects():void
		{
			s.addGameObject(new GameObject())
					.addGameObject(new GameObject())
					.addGameObject(new GameObject());

			assertEquals(s.numGameObjects, 3);
		}

		[Test]
		public function testDisposeWithAllChildren():void
		{
			var c:IGameComponent = new GameComponent();
			var go:IGameObject = new GameObject();
			s.addGameObject(new GameObject())
				.addGameObject(new GameObject())
				.addGameObject(new GameObject())
				.addGameObject(go
					.addComponent(c));

			assertTrue(c.gameObject, go);
			assertTrue(c.parent, go);

			s.disposeWithAllChildren();

			assertTrue(s.isDisposed);
			assertEquals(s.numGameObjects, 0);
			assertTrue(go.isDisposed);
			assertTrue(c.isDisposed);
			assertNull(c.parent, c.gameObject);
		}

		[Test]
		public function testRemoveAllGameObjects():void
		{
			var go_1:IGameObject = new GameObject();
			var go_2:IGameObject = new GameObject();
			var go_3:IGameObject = new GameObject();

			s.addGameObject(go_1).addGameObject(go_2).addGameObject(go_3);
			s.removeAllGameObjects();

			assertEquals(s.numGameObjects, 0);
			assertNull(go_1.parent, go_2.parent, go_3.parent);
			assertNull(go_1.goSystem, go_2.goSystem, go_3.goSystem);
		}

		[Test]
		public function testDispose():void
		{
			var go_1:IGameObject = new GameObject();
			var go_2:IGameObject = new GameObject();
			var go_3:IGameObject = new GameObject();

			s.addGameObject(go_1).addGameObject(go_2).addGameObject(go_3);

			s.dispose();

			assertTrue(s.isDisposed);
			assertEquals(s.numGameObjects, 0);
			assertNull(go_1.parent, go_2.parent, go_3.parent);
			assertNull(go_1.goSystem, go_2.goSystem, go_3.goSystem);
		}

		[Test]
		public function testAdvanceTime():void
		{

		}

		[Test]
		public function testSetJuggler():void
		{
			var m:IMechanism = new EnterFrameMechanism();
			s.setMechanism(m);

			assertEquals(m, s.mechanism);
		}

		[Test]
		public function testRemoveGameObject():void
		{
			var go_1:IGameObject = new GameObject();
			var go_2:IGameObject = new GameObject();
			var go_3:IGameObject = new GameObject();

			s.addGameObject(go_1).addGameObject(go_2).addGameObject(go_3);
			s.removeGameObject(go_2);

			assertEquals(s.numGameObjects, 2);
			assertNull(go_2.goSystem, go_2.parent);
		}

		[Test]
		public function testAddGameObject():void
		{
			assertEquals(s.numGameObjects, 0);
			s.addGameObject(new GameObject());
			assertEquals(s.numGameObjects, 1);
		}

		[Test]
		public function testGameObjectList():void
		{
			assertNull(s.gameObjectList);
			s.addGameObject(new GameObject());
			assertNotNull(s.gameObjectList);
		}

		[Test]
		public function testContainsGameObject():void
		{
			var go_1:IGameObject = new GameObject();
			var go_2:IGameObject = new GameObject();
			var go_3:IGameObject = new GameObject();

			s.addGameObject(go_1).addGameObject(go_2);

			assertTrue(s.containsGameObject(go_1), s.containsGameObject(go_1));
			assertFalse(s.containsGameObject(go_3));
		}
	}
}
