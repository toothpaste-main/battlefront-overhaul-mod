
Light("sun", 2549786237)
{
	Rotation(0.877545, 0.479494, 0.000000, 0.000000);
	Position(-117.855209, 36.527142, -168.889633);
	Type(1);
	Color(1.000000, 1.000000, 1.000000);
	CastShadow();
	Static();
	CastSpecular(1);
	PS2BlendMode(0);
	TileUV(1.000000,1.000000);
	OffsetUV(0.000000,0.000000);
}

GlobalLights()
{
	Light1("sun");
	Light2("");
	Top(255, 255, 255);
	Bottom(128, 128, 128);
}
