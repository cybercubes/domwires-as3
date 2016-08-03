/**
 * Created by Anton Nefjodov on 20.05.2016.
 */
package com.crazyfm.core.factory
{
	import flash.media.Camera;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class AppFactoryTest
	{
		private var factory:IAppFactory;

		[Before]
		public function setUp():void
		{
			GlobalSettings.logEnabled = true;

			factory = new AppFactory();
		}

		[After]
		public function tearDown():void
		{
			factory.clear();
		}

		[Test(expects="Error")]
		public function testUnmapClass():void
		{
			factory.mapToType(IMyType, MyType1);
			var o:IMyType = factory.getInstance(IMyType, [5, 7]) as IMyType;
			factory.unmap(IMyType);
			var o2:IMyType = factory.getInstance(IMyType, [5, 7]) as IMyType;
		}

		[Test(expects="Error")]
		public function testUnmapInstance():void
		{
			var instance:IMyType = new MyType1(5, 7);
			factory.mapToValue(IMyType, o);

			var o:IMyType = factory.getInstance(IMyType) as IMyType;
			assertEquals(o, instance);

			factory.unmap(IMyType);
			var o2:IMyType = factory.getInstance(IMyType) as IMyType;
		}

		[Test]
		public function testGetNewInstance():void
		{
			factory.mapToType(IMyType, MyType1);
			factory.mapToValue(Class, MyType1);
			var o:IMyType = factory.getInstance(IMyType, [5, 7]) as IMyType;
			assertEquals(o.a, 5);
			assertEquals(o.b, 7);
		}

		[Test]
		public function testGetFromPool():void
		{
			factory.mapToType(IMyType, MyType2);
			factory.registerPool(IMyType);
			var o:IMyType = factory.getInstance(IMyType);
			assertEquals(o.a, 500);
			assertEquals(o.b, 700);
		}

		[Test]
		public function testUnregisterPool():void
		{
			factory.registerPool(IMyType);
			assertTrue(factory.hasPoolForType(IMyType));
			factory.unregisterPool(IMyType);
			assertFalse(factory.hasPoolForType(IMyType));
		}

		[Test]
		public function testMapClass():void
		{
			assertFalse(factory.hasMappingForType(IMyType));
			factory.mapToType(IMyType, MyType2);
			assertTrue(factory.hasMappingForType(IMyType));
		}

		[Test]
		public function testMapInstance():void
		{
			var o:IMyType = new MyType2();
			assertFalse(factory.hasMappingForType(IMyType));
			factory.mapToValue(IMyType, o);
			assertTrue(factory.hasMappingForType(IMyType));
			assertEquals(o, factory.getInstance(IMyType));
		}

		[Test]
		public function testRegisterPool():void
		{
			assertFalse(factory.hasPoolForType(IMyType));
			factory.registerPool(IMyType);
			assertTrue(factory.hasPoolForType(IMyType));
		}

		[Test]
		public function clear():void
		{
			factory.mapToType(IMyType, MyType2);
			factory.registerPool(IMyType);
			factory.clear();
			assertFalse(factory.hasMappingForType(IMyType));
			assertFalse(factory.hasPoolForType(IMyType));
		}

		[Test]
		public function testAutowiredAutoInject():void
		{
			var factory:AppFactory = new AppFactory();
			factory.mapToValue(Camera, new Camera());
			factory.mapToValue(Array, []);
			factory.mapToValue(Object, {});

			var obj:DIObject = factory.getInstance(DIObject);
			assertNotNull(obj.c);
			assertNotNull(obj.arr);
			assertNotNull(obj.obj);
		}

		[Test]
		public function testAutowiredManualInject():void
		{
			var factory:AppFactory = new AppFactory();
			factory.mapToValue(Camera, new Camera());
			factory.mapToValue(Array, []);
			factory.mapToValue(Object, {});

			factory.autoInjectDependencies = false;

			var obj:DIObject = factory.getInstance(DIObject);
			assertNull(obj.c);
			factory.injectDependencies(DIObject, obj);
			assertNotNull(obj.c);
			assertNotNull(obj.arr);
			assertNotNull(obj.obj);
		}

		[Test]
		public function testAutowiredAutoInjectPostConstruct():void
		{
			var factory:AppFactory = new AppFactory();
			factory.mapToValue(Camera, new Camera());
			factory.mapToValue(Array, []);
			factory.mapToValue(Object, {});

			var obj:DIObject = factory.getInstance(DIObject);

			assertNotNull(obj.c);
			assertNotNull(obj.arr);
			assertNotNull(obj.obj);
			assertEquals(obj.message, "OK!");
		}

		[Test]
		public function testHasMappingForType():void
		{
			assertFalse(factory.hasMappingForType(IMyType));
			factory.mapToType(IMyType, MyType1);
			assertTrue(factory.hasMappingForType(IMyType));
		}

		[Test]
		public function testGetInstance():void
		{

		}

		[Test]
		public function testHasPoolForType():void
		{
			assertFalse(factory.hasPoolForType(IMyType));
			factory.registerPool(IMyType);
			assertTrue(factory.hasPoolForType(IMyType));
		}

		[Test]
		public function testGetSingleton():void
		{
			var obj:MyType2 = factory.getSingleton(MyType2) as MyType2;
			var obj2:MyType2 = factory.getSingleton(MyType2) as MyType2;
			var obj3:MyType2 = factory.getSingleton(MyType2) as MyType2;

			assertEquals(obj, obj2, obj3);
		}

		[Test]
		public function testRemoveSingleton():void
		{
			var obj:MyType2 = factory.getSingleton(MyType2) as MyType2;
			var obj2:MyType2 = factory.getInstance(MyType2) as MyType2;

			assertTrue(obj == obj2);

			factory.removeSingleton(MyType2);

			obj2 = factory.getInstance(MyType2) as MyType2;

			assertFalse(obj == obj2);
		}

		[Test]
		public function testMapDefaultImplementation_yes():void
		{
			var factory:IAppFactory = new AppFactory();
			var d:IDefault = factory.getInstance(IDefault);
			assertEquals(d.result, 123);
		}

		[Test(expects="Error")]
		public function testMapDefaultImplementation_no():void
		{
			var factory:IAppFactory = new AppFactory();
			var d:IDefault2 = factory.getInstance(IDefault2);
			assertEquals(d.result, 123);
		}

		[Test]
		public function testClassToClassValue():void
		{
			factory.mapToType(IMyType, MyType1);
			factory.mapToValue(Class, MyType1);
			var o:IMyType = factory.getInstance(IMyType, [5, 7]) as IMyType;
			assertEquals(o.a, 5);
			assertEquals(o.b, 7);
			assertFalse(o.clazz is MyType1);
		}

		[Test]
		public function testMappingToName():void
		{
			var arr1:Array = [1,2,3];
			var arr2:Array = [4,5,6];

			factory.mapToValue(Array, arr1, "shachlo");
			factory.mapToValue(Array, arr2, "olo");

			var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj) as MySuperCoolObj;

			assertEquals(myObj.arr1, arr2);
			assertEquals(myObj.arr2, arr1);
		}

		[Test(expects="Error")]
		public function testUnMappingFromName():void
		{
			var arr1:Array = [1,2,3];
			var arr2:Array = [4,5,6];

			factory.mapToValue(Array, arr1, "shachlo");
			factory.mapToValue(Array, arr2, "olo");

			var myObj:MySuperCoolObj = factory.getInstance(MySuperCoolObj) as MySuperCoolObj;

			assertEquals(myObj.arr1, arr2);
			assertEquals(myObj.arr2, arr1);

			factory.unmap(Array, "shachlo");

			factory.getInstance(MySuperCoolObj);
		}

	}
}
internal class MySuperCoolObj
{
	[Autowired(name="olo")]
	public var arr1:Array;

	[Autowired(name="shachlo")]
	public var arr2:Array;

	public function MySuperCoolObj()
	{

	}
}

import flash.media.Camera;

internal class DIObject
{
	[Autowired]
	public var c:Camera;

	[Autowired]
	public var arr:Array;

	[Autowired]
	public var obj:Object;

	private var _message:String;

	public function DIObject()
	{

	}

	[PostConstruct]
	public function init():void
	{
		_message = "OK!";
	}

	public function get message():String
	{
		return _message;
	}
}

internal class MyType1 implements IMyType
{
	private var _a:int;
	private var _b:int;

	[Autowired]
	public var _clazz:Class;

	public function MyType1(a:int, b:int)
	{
		_a = a;
		_b = b;
	}

	public function get a():int
	{
		return _a;
	}

	public function get b():int
	{
		return _b;
	}

	public function get clazz():Class
	{
		return _clazz;
	}
}

internal class MyType2 implements IMyType
{
	public function MyType2()
	{
	}

	public function get a():int
	{
		return 500;
	}

	public function get b():int
	{
		return 700;
	}

	public function get clazz():Class
	{
		return null;
	}
}

internal interface IMyType
{
	function get a():int;
	function get b():int;
	function get clazz():Class;
}