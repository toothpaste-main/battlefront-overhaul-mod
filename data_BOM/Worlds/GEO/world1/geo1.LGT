
Light("sun", 2147348480)
{
	Rotation(-0.409077, -0.872693, 0.262547, -0.046180);
	Position(-0.621802, -0.000795, 0.000000);
	Type(1);
	Color(0.862745, 0.862745, 0.862745);
	CastShadow();
	Static();
	CastSpecular(1);
	PS2BlendMode(0);
	TileUV(1.000000,1.000000);
	OffsetUV(0.000000,0.000000);
}

Light("Light 1", 2147483647)
{
	Rotation(0.873074, 0.475439, -0.056381, -0.092730);
	Position(31.851360, -55.997898, -73.289841);
	Type(3);
	Color(0.000000, 0.000000, 1.000000);
	Static();
	Range(5.000000);
	Cone(0.785398, 0.872665);
	PS2BlendMode(0);
	Bidirectional(0);
}

Light("arden11", 2147483647)
{
	Rotation(0.724116, 0.689689, -0.000000, -0.000000);
	Position(114.252220, -32.664917, -161.031937);
	Type(3);
	Color(0.968628, 0.866667, 0.658824);
	Static();
	PS2Overbright(1);
	Range(15.000000);
	Cone(0.698132, 1.047198);
	PS2BlendMode(0);
	Bidirectional(0);
}

GlobalLights()
{
	Light1("Sun");
	Light2("");
	Top(100, 80, 50);
	Bottom(90, 60, 30);
}
