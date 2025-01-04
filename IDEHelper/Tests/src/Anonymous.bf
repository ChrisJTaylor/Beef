using System;
namespace Tests;

class Anonymous
{
	struct StructA
	{
		public [Union] struct { public int mX, mY; } mVals;

		[CRepr, SkipCall] struct { public int mA, mB; } GetVals()
		{
			decltype(GetVals()) retVals;
			retVals.mA = 1;
			retVals.mB = 2;
			return retVals;
		}

		public enum { Left, Right } GetDirection() => .Right;

		public enum : int { A, B, C } Val => .C;
	}

	struct StructB
	{
		[Union]
		public using struct
		{
			public int mX;
			public int mY;
		} mCoords;
	}

	struct StructC
	{
		public int mA;

		public this(int a)
		{
			mA = a;
		}
	}

	class ClassA
	{
		public int Val = 123;
	}

	[Test]
	public static void TestBasics()
	{
		StructA sa = default;
		sa.mVals.mX = 123;
		Test.Assert(sa.mVals.mY == 123);
		
		var val = sa.[Friend]GetVals();
		Test.Assert(val.mA == 0);
		Test.Assert(val.mB == 0);

		Test.Assert(sa.GetDirection() == .Right);
		Test.Assert(sa.Val == .C);

		StructB sb = default;
		sb.mX = 345;
		Test.Assert(sb.mY == 345);

		var sc = StructC(456)
			{
				public int mB = 567;

				{
					_.mB += 1000;
				},
				mB += 10000
			};
		Test.Assert(sc.mA == 456);
		Test.Assert(sc.mB == 11567);

		var ca = scope ClassA()
			{
				public override void ToString(String strBuffer)
				{
					strBuffer.Append("ClassA override");
				}
			};

		var str = ca.ToString(.. scope .());
		Test.Assert(str == "ClassA override");
	}
}