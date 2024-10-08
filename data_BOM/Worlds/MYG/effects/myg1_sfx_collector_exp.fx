ParticleEmitter("Explosion1")
{
	MaxParticles(4.0000,4.0000);
	StartDelay(0.0000,0.0000);
	BurstDelay(0.0010, 0.0010);
	BurstCount(4.0000,4.0000);
	MaxLodDist(2100.0000);
	MinLodDist(2000.0000);
	BoundingRadius(30.0);
	SoundName("")
	NoRegisterStep();
	Size(1.0000, 1.0000);
	Hue(255.0000, 255.0000);
	Saturation(255.0000, 255.0000);
	Value(255.0000, 255.0000);
	Alpha(255.0000, 255.0000);
	Spawner()
	{
		Circle()
		{
			PositionX(1.0000,5.0000);
			PositionY(0.0000,1.0000);
			PositionZ(-2.0000,2.0000);
		}
		Offset()
		{
			PositionX(20.0000,20.0000);
			PositionY(4.0000,4.0000);
			PositionZ(0.0000,0.0000);
		}
		PositionScale(1.5000,1.5000);
		VelocityScale(20.0000,35.0000);
		InheritVelocityFactor(0.0000,0.0000);
		Size(0, 2.7000, 5.4000);
		Red(0, 255.0000, 255.0000);
		Green(0, 255.0000, 255.0000);
		Blue(0, 255.0000, 255.0000);
		Alpha(0, 255.0000, 255.0000);
		StartRotation(0, 0.0000, 360.0000);
		RotationVelocity(0, -100.0000, 100.0000);
		FadeInTime(0.0000);
	}
	Transformer()
	{
		LifeTime(2.5000);
		Position()
		{
			LifeTime(1.2500)
		}
		Size(0)
		{
			LifeTime(1.8750)
		}
		Color(0)
		{
			LifeTime(1.8750)
			Reach(255.0000,255.0000,255.0000,255.0000);
		}
	}
	Geometry()
	{
		BlendMode("NORMAL");
		Type("EMITTER");
		Texture("explode3");
		ParticleEmitter("Smoke")
		{
			MaxParticles(4.0000,4.0000);
			StartDelay(0.0000,0.0000);
			BurstDelay(0.0750, 0.0750);
			BurstCount(1.0000,1.0000);
			MaxLodDist(1000.0000);
			MinLodDist(800.0000);
			BoundingRadius(30.0);
			SoundName("")
			Size(1.0000, 1.0000);
			Hue(255.0000, 255.0000);
			Saturation(255.0000, 255.0000);
			Value(255.0000, 255.0000);
			Alpha(255.0000, 255.0000);
			Spawner()
			{
				Circle()
				{
					PositionX(-2.7000,2.7000);
					PositionY(-2.7000,2.7000);
					PositionZ(-2.7000,2.7000);
				}
				Offset()
				{
					PositionX(0.0000,0.0000);
					PositionY(0.0000,0.0000);
					PositionZ(0.0000,0.0000);
				}
				PositionScale(0.0000,0.0000);
				VelocityScale(1.3500,1.3500);
				InheritVelocityFactor(0.2500,0.2500);
				Size(0, 2.0000, 3.5000);
				Hue(0, 0.0000, 0.0000);
				Saturation(0, 0.0000, 0.0000);
				Value(0, 150.0000, 255.0000);
				Alpha(0, 0.0000, 128.0000);
				StartRotation(0, 0.0000, 360.0000);
				RotationVelocity(0, -90.0000, 90.0000);
				FadeInTime(0.0000);
			}
			Transformer()
			{
				LifeTime(1.8750);
				Position()
				{
					LifeTime(1.8750)
					Scale(0.0000);
				}
				Size(0)
				{
					LifeTime(0.3125)
					Scale(2.5000);
					Next()
					{
						LifeTime(1.5625)
						Scale(2.5000);
					}
				}
				Color(0)
				{
					LifeTime(0.1250)
					Move(0.0000,0.0000,0.0000,128.0000);
					Next()
					{
						LifeTime(1.7500)
						Move(0.0000,0.0000,-128.0000,-255.0000);
					}
				}
			}
			Geometry()
			{
				BlendMode("NORMAL");
				Type("PARTICLE");
				Texture("com_sfx_smoke1");
				ParticleEmitter("BlackSmoke")
				{
					MaxParticles(4.0000,4.0000);
					StartDelay(0.0000,0.0000);
					BurstDelay(0.0250, 0.0250);
					BurstCount(1.0000,1.0000);
					MaxLodDist(50.0000);
					MinLodDist(10.0000);
					BoundingRadius(5.0);
					SoundName("")
					Size(1.0000, 1.0000);
					Hue(255.0000, 255.0000);
					Saturation(255.0000, 255.0000);
					Value(255.0000, 255.0000);
					Alpha(255.0000, 255.0000);
					Spawner()
					{
						Spread()
						{
							PositionX(-7.0875,7.0875);
							PositionY(-7.0875,7.0875);
							PositionZ(-7.0875,7.0875);
						}
						Offset()
						{
							PositionX(-0.3546,0.3546);
							PositionY(-0.3546,0.3546);
							PositionZ(-0.3546,0.3546);
						}
						PositionScale(0.0000,0.0000);
						VelocityScale(7.0875,7.0875);
						InheritVelocityFactor(0.2000,0.2000);
						Size(0, 3.5439, 4.9614);
						Hue(0, 12.0000, 20.0000);
						Saturation(0, 5.0000, 10.0000);
						Value(0, 200.0000, 220.0000);
						Alpha(0, 0.0000, 0.0000);
						StartRotation(0, -20.0000, 20.0000);
						RotationVelocity(0, -20.0000, 20.0000);
						FadeInTime(0.0000);
					}
					Transformer()
					{
						LifeTime(1.8750);
						Position()
						{
							LifeTime(1.8750)
							Scale(0.0000);
						}
						Size(0)
						{
							LifeTime(2.5000)
							Scale(6.0000);
						}
						Color(0)
						{
							LifeTime(0.1250)
							Move(0.0000,0.0000,0.0000,255.0000);
							Next()
							{
								LifeTime(1.7500)
								Move(0.0000,0.0000,0.0000,-255.0000);
							}
						}
					}
					Geometry()
					{
						BlendMode("NORMAL");
						Type("PARTICLE");
						Texture("thicksmoke3");
					}
				}
			}
			ParticleEmitter("Flames")
			{
				MaxParticles(4.0000,4.0000);
				StartDelay(0.0000,0.0000);
				BurstDelay(0.0750, 0.0750);
				BurstCount(1.0000,1.0000);
				MaxLodDist(1000.0000);
				MinLodDist(800.0000);
				BoundingRadius(30.0);
				SoundName("")
				Size(1.0000, 1.0000);
				Hue(255.0000, 255.0000);
				Saturation(255.0000, 255.0000);
				Value(255.0000, 255.0000);
				Alpha(255.0000, 255.0000);
				Spawner()
				{
					Circle()
					{
						PositionX(-2.7000,2.7000);
						PositionY(-2.7000,2.7000);
						PositionZ(-2.7000,2.7000);
					}
					Offset()
					{
						PositionX(-0.2700,0.2700);
						PositionY(-0.2700,0.2700);
						PositionZ(-0.2700,0.2700);
					}
					PositionScale(0.0000,0.0000);
					VelocityScale(2.7000,2.7000);
					InheritVelocityFactor(0.2500,0.2500);
					Size(0, 0.5000, 1.0000);
					Red(0, 255.0000, 255.0000);
					Green(0, 204.0000, 233.0000);
					Blue(0, 98.0000, 185.0000);
					Alpha(0, 0.0000, 128.0000);
					StartRotation(0, 0.0000, 255.0000);
					RotationVelocity(0, -160.0000, 160.0000);
					FadeInTime(0.0000);
				}
				Transformer()
				{
					LifeTime(1.2500);
					Position()
					{
						LifeTime(1.2500)
						Scale(0.0000);
					}
					Size(0)
					{
						LifeTime(0.1250)
						Scale(4.0000);
						Next()
						{
							LifeTime(1.1250)
							Scale(3.0000);
						}
					}
					Color(0)
					{
						LifeTime(0.1250)
						Move(0.0000,-40.0000,-50.0000,128.0000);
						Next()
						{
							LifeTime(0.6250)
							Move(128.0000,-40.0000,-50.0000,-128.0000);
							Next()
							{
								LifeTime(0.5000)
								Move(128.0000,-50.0000,-50.0000,-128.0000);
							}
						}
					}
				}
				Geometry()
				{
					BlendMode("ADDITIVE");
					Type("PARTICLE");
					Texture("com_sfx_explosion1");
					ParticleEmitter("BlackSmoke")
					{
						MaxParticles(3.0000,3.0000);
						StartDelay(0.0000,0.0000);
						BurstDelay(0.0250, 0.0250);
						BurstCount(1.0000,1.0000);
						MaxLodDist(50.0000);
						MinLodDist(10.0000);
						BoundingRadius(5.0);
						SoundName("")
						Size(1.0000, 1.0000);
						Hue(255.0000, 255.0000);
						Saturation(255.0000, 255.0000);
						Value(255.0000, 255.0000);
						Alpha(255.0000, 255.0000);
						Spawner()
						{
							Spread()
							{
								PositionX(-7.0875,7.0875);
								PositionY(-7.0875,7.0875);
								PositionZ(-7.0875,7.0875);
							}
							Offset()
							{
								PositionX(-0.3546,0.3546);
								PositionY(-0.3546,0.3546);
								PositionZ(-0.3546,0.3546);
							}
							PositionScale(0.0000,0.0000);
							VelocityScale(10.1250,10.1250);
							InheritVelocityFactor(0.1000,0.1000);
							Size(0, 1.4175, 2.8350);
							Red(0, 254.0000, 255.0000);
							Green(0, 172.0000, 179.0000);
							Blue(0, 75.0000, 89.0000);
							Alpha(0, 0.0000, 0.0000);
							StartRotation(0, -20.0000, 20.0000);
							RotationVelocity(0, -20.0000, 20.0000);
							FadeInTime(0.0000);
						}
						Transformer()
						{
							LifeTime(1.5625);
							Position()
							{
								LifeTime(1.8750)
								Scale(0.0000);
							}
							Size(0)
							{
								LifeTime(1.5625)
								Scale(5.0000);
							}
							Color(0)
							{
								LifeTime(0.0125)
								Move(0.0000,0.0000,0.0000,48.0000);
								Next()
								{
									LifeTime(1.5500)
									Move(0.0000,0.0000,0.0000,-64.0000);
								}
							}
						}
						Geometry()
						{
							BlendMode("ADDITIVE");
							Type("PARTICLE");
							Texture("thicksmoke3");
						}
					}
				}
			}
		}
	}
	ParticleEmitter("Flare1")
	{
		MaxParticles(5.0000,5.0000);
		StartDelay(0.0000,0.0000);
		BurstDelay(0.0000, 0.0000);
		BurstCount(5.0000,5.0000);
		MaxLodDist(2100.0000);
		MinLodDist(2000.0000);
		BoundingRadius(5.0);
		SoundName("")
		NoRegisterStep();
		Size(1.0000, 1.0000);
		Hue(255.0000, 255.0000);
		Saturation(255.0000, 255.0000);
		Value(255.0000, 255.0000);
		Alpha(255.0000, 255.0000);
		Spawner()
		{
			Spread()
			{
				PositionX(0.0000,0.0000);
				PositionY(0.0000,0.0000);
				PositionZ(0.0000,0.0000);
			}
			Offset()
			{
				PositionX(20.0000,20.0000);
				PositionY(4.0000,4.0000);
				PositionZ(0.0000,0.0000);
			}
			PositionScale(0.0000,0.0000);
			VelocityScale(0.0000,0.0000);
			InheritVelocityFactor(0.0000,0.0000);
			Size(0, 14.0000, 14.0000);
			Red(0, 255.0000, 255.0000);
			Green(0, 240.0000, 240.0000);
			Blue(0, 200.0000, 200.0000);
			Alpha(0, 128.0000, 128.0000);
			StartRotation(0, 1.0000, 1.9000);
			RotationVelocity(0, 0.0000, 0.0000);
			FadeInTime(0.0000);
		}
		Transformer()
		{
			LifeTime(1.2500);
			Position()
			{
				LifeTime(1.2500)
			}
			Size(0)
			{
				LifeTime(0.1250)
			}
			Color(0)
			{
				LifeTime(1.2500)
				Move(0.0000,0.0000,0.0000,-128.0000);
			}
		}
		Geometry()
		{
			BlendMode("ADDITIVE");
			Type("PARTICLE");
			Texture("com_sfx_flashball3");
		}
		ParticleEmitter("Sparks1")
		{
			MaxParticles(10.0000,10.0000);
			StartDelay(0.0000,0.0000);
			BurstDelay(0.0010, 0.0010);
			BurstCount(5.0000,5.0000);
			MaxLodDist(2100.0000);
			MinLodDist(2000.0000);
			BoundingRadius(5.0);
			SoundName("")
			NoRegisterStep();
			Size(1.0000, 1.0000);
			Red(255.0000, 255.0000);
			Green(255.0000, 255.0000);
			Blue(255.0000, 255.0000);
			Alpha(255.0000, 255.0000);
			Spawner()
			{
				Circle()
				{
					PositionX(1.0000,1.5000);
					PositionY(0.0000,1.5000);
					PositionZ(-1.0000,1.0000);
				}
				Offset()
				{
					PositionX(20.0000,20.0000);
					PositionY(4.0000,4.0000);
					PositionZ(0.0000,0.0000);
				}
				PositionScale(1.5000,4.5000);
				VelocityScale(3.0000,33.0000);
				InheritVelocityFactor(0.0000,0.0000);
				Size(0, 0.0375, 0.0750);
				Red(0, 255.0000, 255.0000);
				Green(0, 255.0000, 255.0000);
				Blue(0, 255.0000, 255.0000);
				Alpha(0, 255.0000, 255.0000);
				StartRotation(0, 0.0000, 360.0000);
				RotationVelocity(0, -100.0000, 100.0000);
				FadeInTime(0.0000);
			}
			Transformer()
			{
				LifeTime(2.5000);
				Position()
				{
					LifeTime(2.5000)
					Accelerate(0.0000, -45.0000, 0.0000);
				}
				Size(0)
				{
					LifeTime(2.5000)
					Scale(0.0000);
				}
				Color(0)
				{
					LifeTime(2.5000)
					Move(0.0000,0.0000,0.0000,-255.0000);
				}
			}
			Geometry()
			{
				BlendMode("ADDITIVE");
				Type("SPARK");
				SparkLength(0.0500);
				Texture("com_sfx_laser_orange");
			}
			ParticleEmitter("Explosion2")
			{
				MaxParticles(4.0000,4.0000);
				StartDelay(0.0000,0.0000);
				BurstDelay(0.0010, 0.0010);
				BurstCount(4.0000,4.0000);
				MaxLodDist(2100.0000);
				MinLodDist(2000.0000);
				BoundingRadius(30.0);
				SoundName("")
				NoRegisterStep();
				Size(1.0000, 1.0000);
				Hue(255.0000, 255.0000);
				Saturation(255.0000, 255.0000);
				Value(255.0000, 255.0000);
				Alpha(255.0000, 255.0000);
				Spawner()
				{
					Circle()
					{
						PositionX(-5.0000,-1.0000);
						PositionY(0.0000,1.0000);
						PositionZ(-2.0000,2.0000);
					}
					Offset()
					{
						PositionX(-20.0000,-20.0000);
						PositionY(4.0000,4.0000);
						PositionZ(0.0000,0.0000);
					}
					PositionScale(1.5000,1.5000);
					VelocityScale(20.0000,35.0000);
					InheritVelocityFactor(0.0000,0.0000);
					Size(0, 2.7000, 5.4000);
					Red(0, 255.0000, 255.0000);
					Green(0, 255.0000, 255.0000);
					Blue(0, 255.0000, 255.0000);
					Alpha(0, 255.0000, 255.0000);
					StartRotation(0, 0.0000, 360.0000);
					RotationVelocity(0, -100.0000, 100.0000);
					FadeInTime(0.0000);
				}
				Transformer()
				{
					LifeTime(2.5000);
					Position()
					{
						LifeTime(1.2500)
					}
					Size(0)
					{
						LifeTime(1.8750)
					}
					Color(0)
					{
						LifeTime(1.8750)
						Reach(255.0000,255.0000,255.0000,255.0000);
					}
				}
				Geometry()
				{
					BlendMode("NORMAL");
					Type("EMITTER");
					Texture("explode3");
					ParticleEmitter("Smoke")
					{
						MaxParticles(4.0000,4.0000);
						StartDelay(0.0000,0.0000);
						BurstDelay(0.0750, 0.0750);
						BurstCount(1.0000,1.0000);
						MaxLodDist(1000.0000);
						MinLodDist(800.0000);
						BoundingRadius(30.0);
						SoundName("")
						Size(1.0000, 1.0000);
						Hue(255.0000, 255.0000);
						Saturation(255.0000, 255.0000);
						Value(255.0000, 255.0000);
						Alpha(255.0000, 255.0000);
						Spawner()
						{
							Circle()
							{
								PositionX(-2.7000,2.7000);
								PositionY(-2.7000,2.7000);
								PositionZ(-2.7000,2.7000);
							}
							Offset()
							{
								PositionX(0.0000,0.0000);
								PositionY(0.0000,0.0000);
								PositionZ(0.0000,0.0000);
							}
							PositionScale(0.0000,0.0000);
							VelocityScale(1.3500,1.3500);
							InheritVelocityFactor(0.2500,0.2500);
							Size(0, 2.0000, 3.5000);
							Hue(0, 0.0000, 0.0000);
							Saturation(0, 0.0000, 0.0000);
							Value(0, 150.0000, 255.0000);
							Alpha(0, 0.0000, 128.0000);
							StartRotation(0, 0.0000, 360.0000);
							RotationVelocity(0, -90.0000, 90.0000);
							FadeInTime(0.0000);
						}
						Transformer()
						{
							LifeTime(1.8750);
							Position()
							{
								LifeTime(1.8750)
								Scale(0.0000);
							}
							Size(0)
							{
								LifeTime(0.3125)
								Scale(2.5000);
								Next()
								{
									LifeTime(1.5625)
									Scale(2.5000);
								}
							}
							Color(0)
							{
								LifeTime(0.1250)
								Move(0.0000,0.0000,0.0000,128.0000);
								Next()
								{
									LifeTime(1.7500)
									Move(0.0000,0.0000,-128.0000,-255.0000);
								}
							}
						}
						Geometry()
						{
							BlendMode("NORMAL");
							Type("PARTICLE");
							Texture("com_sfx_smoke1");
							ParticleEmitter("BlackSmoke")
							{
								MaxParticles(4.0000,4.0000);
								StartDelay(0.0000,0.0000);
								BurstDelay(0.0250, 0.0250);
								BurstCount(1.0000,1.0000);
								MaxLodDist(50.0000);
								MinLodDist(10.0000);
								BoundingRadius(5.0);
								SoundName("")
								Size(1.0000, 1.0000);
								Hue(255.0000, 255.0000);
								Saturation(255.0000, 255.0000);
								Value(255.0000, 255.0000);
								Alpha(255.0000, 255.0000);
								Spawner()
								{
									Spread()
									{
										PositionX(-7.0875,7.0875);
										PositionY(-7.0875,7.0875);
										PositionZ(-7.0875,7.0875);
									}
									Offset()
									{
										PositionX(-0.3546,0.3546);
										PositionY(-0.3546,0.3546);
										PositionZ(-0.3546,0.3546);
									}
									PositionScale(0.0000,0.0000);
									VelocityScale(7.0875,7.0875);
									InheritVelocityFactor(0.2000,0.2000);
									Size(0, 3.5439, 4.9614);
									Hue(0, 12.0000, 20.0000);
									Saturation(0, 5.0000, 10.0000);
									Value(0, 200.0000, 220.0000);
									Alpha(0, 0.0000, 0.0000);
									StartRotation(0, -20.0000, 20.0000);
									RotationVelocity(0, -20.0000, 20.0000);
									FadeInTime(0.0000);
								}
								Transformer()
								{
									LifeTime(1.8750);
									Position()
									{
										LifeTime(1.8750)
										Scale(0.0000);
									}
									Size(0)
									{
										LifeTime(2.5000)
										Scale(6.0000);
									}
									Color(0)
									{
										LifeTime(0.1250)
										Move(0.0000,0.0000,0.0000,255.0000);
										Next()
										{
											LifeTime(1.7500)
											Move(0.0000,0.0000,0.0000,-255.0000);
										}
									}
								}
								Geometry()
								{
									BlendMode("NORMAL");
									Type("PARTICLE");
									Texture("thicksmoke3");
								}
							}
						}
						ParticleEmitter("Flames")
						{
							MaxParticles(4.0000,4.0000);
							StartDelay(0.0000,0.0000);
							BurstDelay(0.0750, 0.0750);
							BurstCount(1.0000,1.0000);
							MaxLodDist(1000.0000);
							MinLodDist(800.0000);
							BoundingRadius(30.0);
							SoundName("")
							Size(1.0000, 1.0000);
							Hue(255.0000, 255.0000);
							Saturation(255.0000, 255.0000);
							Value(255.0000, 255.0000);
							Alpha(255.0000, 255.0000);
							Spawner()
							{
								Circle()
								{
									PositionX(-2.7000,2.7000);
									PositionY(-2.7000,2.7000);
									PositionZ(-2.7000,2.7000);
								}
								Offset()
								{
									PositionX(-0.2700,0.2700);
									PositionY(-0.2700,0.2700);
									PositionZ(-0.2700,0.2700);
								}
								PositionScale(0.0000,0.0000);
								VelocityScale(2.7000,2.7000);
								InheritVelocityFactor(0.2500,0.2500);
								Size(0, 0.5000, 1.0000);
								Red(0, 255.0000, 255.0000);
								Green(0, 204.0000, 233.0000);
								Blue(0, 98.0000, 185.0000);
								Alpha(0, 0.0000, 128.0000);
								StartRotation(0, 0.0000, 255.0000);
								RotationVelocity(0, -160.0000, 160.0000);
								FadeInTime(0.0000);
							}
							Transformer()
							{
								LifeTime(1.2500);
								Position()
								{
									LifeTime(1.2500)
									Scale(0.0000);
								}
								Size(0)
								{
									LifeTime(0.1250)
									Scale(4.0000);
									Next()
									{
										LifeTime(1.1250)
										Scale(3.0000);
									}
								}
								Color(0)
								{
									LifeTime(0.1250)
									Move(0.0000,-40.0000,-50.0000,128.0000);
									Next()
									{
										LifeTime(0.6250)
										Move(128.0000,-40.0000,-50.0000,-128.0000);
										Next()
										{
											LifeTime(0.5000)
											Move(128.0000,-50.0000,-50.0000,-128.0000);
										}
									}
								}
							}
							Geometry()
							{
								BlendMode("ADDITIVE");
								Type("PARTICLE");
								Texture("com_sfx_explosion1");
								ParticleEmitter("BlackSmoke")
								{
									MaxParticles(3.0000,3.0000);
									StartDelay(0.0000,0.0000);
									BurstDelay(0.0250, 0.0250);
									BurstCount(1.0000,1.0000);
									MaxLodDist(50.0000);
									MinLodDist(10.0000);
									BoundingRadius(5.0);
									SoundName("")
									Size(1.0000, 1.0000);
									Hue(255.0000, 255.0000);
									Saturation(255.0000, 255.0000);
									Value(255.0000, 255.0000);
									Alpha(255.0000, 255.0000);
									Spawner()
									{
										Spread()
										{
											PositionX(-7.0875,7.0875);
											PositionY(-7.0875,7.0875);
											PositionZ(-7.0875,7.0875);
										}
										Offset()
										{
											PositionX(-0.3546,0.3546);
											PositionY(-0.3546,0.3546);
											PositionZ(-0.3546,0.3546);
										}
										PositionScale(0.0000,0.0000);
										VelocityScale(10.1250,10.1250);
										InheritVelocityFactor(0.1000,0.1000);
										Size(0, 1.4175, 2.8350);
										Red(0, 254.0000, 255.0000);
										Green(0, 172.0000, 179.0000);
										Blue(0, 75.0000, 89.0000);
										Alpha(0, 0.0000, 0.0000);
										StartRotation(0, -20.0000, 20.0000);
										RotationVelocity(0, -20.0000, 20.0000);
										FadeInTime(0.0000);
									}
									Transformer()
									{
										LifeTime(1.5625);
										Position()
										{
											LifeTime(1.8750)
											Scale(0.0000);
										}
										Size(0)
										{
											LifeTime(1.5625)
											Scale(5.0000);
										}
										Color(0)
										{
											LifeTime(0.0125)
											Move(0.0000,0.0000,0.0000,48.0000);
											Next()
											{
												LifeTime(1.5500)
												Move(0.0000,0.0000,0.0000,-64.0000);
											}
										}
									}
									Geometry()
									{
										BlendMode("ADDITIVE");
										Type("PARTICLE");
										Texture("thicksmoke3");
									}
								}
							}
						}
					}
				}
				ParticleEmitter("Flare2")
				{
					MaxParticles(5.0000,5.0000);
					StartDelay(0.0000,0.0000);
					BurstDelay(0.0000, 0.0000);
					BurstCount(5.0000,5.0000);
					MaxLodDist(2100.0000);
					MinLodDist(2000.0000);
					BoundingRadius(5.0);
					SoundName("")
					NoRegisterStep();
					Size(1.0000, 1.0000);
					Hue(255.0000, 255.0000);
					Saturation(255.0000, 255.0000);
					Value(255.0000, 255.0000);
					Alpha(255.0000, 255.0000);
					Spawner()
					{
						Spread()
						{
							PositionX(0.0000,0.0000);
							PositionY(0.0000,0.0000);
							PositionZ(0.0000,0.0000);
						}
						Offset()
						{
							PositionX(-20.0000,-20.0000);
							PositionY(4.0000,4.0000);
							PositionZ(0.0000,0.0000);
						}
						PositionScale(0.0000,0.0000);
						VelocityScale(0.0000,0.0000);
						InheritVelocityFactor(0.0000,0.0000);
						Size(0, 14.0000, 14.0000);
						Red(0, 255.0000, 255.0000);
						Green(0, 240.0000, 240.0000);
						Blue(0, 200.0000, 200.0000);
						Alpha(0, 128.0000, 128.0000);
						StartRotation(0, 1.0000, 1.9000);
						RotationVelocity(0, 0.0000, 0.0000);
						FadeInTime(0.0000);
					}
					Transformer()
					{
						LifeTime(1.2500);
						Position()
						{
							LifeTime(1.2500)
						}
						Size(0)
						{
							LifeTime(0.1250)
						}
						Color(0)
						{
							LifeTime(1.2500)
							Move(0.0000,0.0000,0.0000,-128.0000);
						}
					}
					Geometry()
					{
						BlendMode("ADDITIVE");
						Type("PARTICLE");
						Texture("com_sfx_flashball3");
					}
					ParticleEmitter("Sparks2")
					{
						MaxParticles(10.0000,10.0000);
						StartDelay(0.0000,0.0000);
						BurstDelay(0.0010, 0.0010);
						BurstCount(5.0000,5.0000);
						MaxLodDist(2100.0000);
						MinLodDist(2000.0000);
						BoundingRadius(5.0);
						SoundName("")
						NoRegisterStep();
						Size(1.0000, 1.0000);
						Red(255.0000, 255.0000);
						Green(255.0000, 255.0000);
						Blue(255.0000, 255.0000);
						Alpha(255.0000, 255.0000);
						Spawner()
						{
							Circle()
							{
								PositionX(-1.5000,-1.0000);
								PositionY(0.0000,1.5000);
								PositionZ(-1.0000,1.0000);
							}
							Offset()
							{
								PositionX(-20.0000,-20.0000);
								PositionY(4.0000,4.0000);
								PositionZ(0.0000,0.0000);
							}
							PositionScale(1.5000,4.5000);
							VelocityScale(3.0000,33.0000);
							InheritVelocityFactor(0.0000,0.0000);
							Size(0, 0.0375, 0.0750);
							Red(0, 255.0000, 255.0000);
							Green(0, 255.0000, 255.0000);
							Blue(0, 255.0000, 255.0000);
							Alpha(0, 255.0000, 255.0000);
							StartRotation(0, 0.0000, 360.0000);
							RotationVelocity(0, -100.0000, 100.0000);
							FadeInTime(0.0000);
						}
						Transformer()
						{
							LifeTime(2.5000);
							Position()
							{
								LifeTime(2.5000)
								Accelerate(0.0000, -45.0000, 0.0000);
							}
							Size(0)
							{
								LifeTime(2.5000)
								Scale(0.0000);
							}
							Color(0)
							{
								LifeTime(2.5000)
								Move(0.0000,0.0000,0.0000,-255.0000);
							}
						}
						Geometry()
						{
							BlendMode("ADDITIVE");
							Type("SPARK");
							SparkLength(0.0500);
							Texture("com_sfx_laser_orange");
						}
						ParticleEmitter("Explosion3")
						{
							MaxParticles(4.0000,4.0000);
							StartDelay(0.0000,0.0000);
							BurstDelay(0.0010, 0.0010);
							BurstCount(4.0000,4.0000);
							MaxLodDist(2100.0000);
							MinLodDist(2000.0000);
							BoundingRadius(30.0);
							SoundName("")
							NoRegisterStep();
							Size(1.0000, 1.0000);
							Hue(255.0000, 255.0000);
							Saturation(255.0000, 255.0000);
							Value(255.0000, 255.0000);
							Alpha(255.0000, 255.0000);
							Spawner()
							{
								Circle()
								{
									PositionX(-2.0000,2.0000);
									PositionY(0.0000,1.0000);
									PositionZ(1.0000,5.0000);
								}
								Offset()
								{
									PositionX(0.0000,0.0000);
									PositionY(4.0000,4.0000);
									PositionZ(20.0000,20.0000);
								}
								PositionScale(1.5000,1.5000);
								VelocityScale(20.0000,35.0000);
								InheritVelocityFactor(0.0000,0.0000);
								Size(0, 2.7000, 5.4000);
								Red(0, 255.0000, 255.0000);
								Green(0, 255.0000, 255.0000);
								Blue(0, 255.0000, 255.0000);
								Alpha(0, 255.0000, 255.0000);
								StartRotation(0, 0.0000, 360.0000);
								RotationVelocity(0, -100.0000, 100.0000);
								FadeInTime(0.0000);
							}
							Transformer()
							{
								LifeTime(2.5000);
								Position()
								{
									LifeTime(1.2500)
								}
								Size(0)
								{
									LifeTime(1.8750)
								}
								Color(0)
								{
									LifeTime(1.8750)
									Reach(255.0000,255.0000,255.0000,255.0000);
								}
							}
							Geometry()
							{
								BlendMode("NORMAL");
								Type("EMITTER");
								Texture("explode3");
								ParticleEmitter("Smoke")
								{
									MaxParticles(4.0000,4.0000);
									StartDelay(0.0000,0.0000);
									BurstDelay(0.0750, 0.0750);
									BurstCount(1.0000,1.0000);
									MaxLodDist(1000.0000);
									MinLodDist(800.0000);
									BoundingRadius(30.0);
									SoundName("")
									Size(1.0000, 1.0000);
									Hue(255.0000, 255.0000);
									Saturation(255.0000, 255.0000);
									Value(255.0000, 255.0000);
									Alpha(255.0000, 255.0000);
									Spawner()
									{
										Circle()
										{
											PositionX(-2.7000,2.7000);
											PositionY(-2.7000,2.7000);
											PositionZ(-2.7000,2.7000);
										}
										Offset()
										{
											PositionX(0.0000,0.0000);
											PositionY(0.0000,0.0000);
											PositionZ(0.0000,0.0000);
										}
										PositionScale(0.0000,0.0000);
										VelocityScale(1.3500,1.3500);
										InheritVelocityFactor(0.2500,0.2500);
										Size(0, 2.0000, 3.5000);
										Hue(0, 0.0000, 0.0000);
										Saturation(0, 0.0000, 0.0000);
										Value(0, 150.0000, 255.0000);
										Alpha(0, 0.0000, 128.0000);
										StartRotation(0, 0.0000, 360.0000);
										RotationVelocity(0, -90.0000, 90.0000);
										FadeInTime(0.0000);
									}
									Transformer()
									{
										LifeTime(1.8750);
										Position()
										{
											LifeTime(1.8750)
											Scale(0.0000);
										}
										Size(0)
										{
											LifeTime(0.3125)
											Scale(2.5000);
											Next()
											{
												LifeTime(1.5625)
												Scale(2.5000);
											}
										}
										Color(0)
										{
											LifeTime(0.1250)
											Move(0.0000,0.0000,0.0000,128.0000);
											Next()
											{
												LifeTime(1.7500)
												Move(0.0000,0.0000,-128.0000,-255.0000);
											}
										}
									}
									Geometry()
									{
										BlendMode("NORMAL");
										Type("PARTICLE");
										Texture("com_sfx_smoke1");
										ParticleEmitter("BlackSmoke")
										{
											MaxParticles(4.0000,4.0000);
											StartDelay(0.0000,0.0000);
											BurstDelay(0.0250, 0.0250);
											BurstCount(1.0000,1.0000);
											MaxLodDist(50.0000);
											MinLodDist(10.0000);
											BoundingRadius(5.0);
											SoundName("")
											Size(1.0000, 1.0000);
											Hue(255.0000, 255.0000);
											Saturation(255.0000, 255.0000);
											Value(255.0000, 255.0000);
											Alpha(255.0000, 255.0000);
											Spawner()
											{
												Spread()
												{
													PositionX(-7.0875,7.0875);
													PositionY(-7.0875,7.0875);
													PositionZ(-7.0875,7.0875);
												}
												Offset()
												{
													PositionX(-0.3546,0.3546);
													PositionY(-0.3546,0.3546);
													PositionZ(-0.3546,0.3546);
												}
												PositionScale(0.0000,0.0000);
												VelocityScale(7.0875,7.0875);
												InheritVelocityFactor(0.2000,0.2000);
												Size(0, 3.5439, 4.9614);
												Hue(0, 12.0000, 20.0000);
												Saturation(0, 5.0000, 10.0000);
												Value(0, 200.0000, 220.0000);
												Alpha(0, 0.0000, 0.0000);
												StartRotation(0, -20.0000, 20.0000);
												RotationVelocity(0, -20.0000, 20.0000);
												FadeInTime(0.0000);
											}
											Transformer()
											{
												LifeTime(1.8750);
												Position()
												{
													LifeTime(1.8750)
													Scale(0.0000);
												}
												Size(0)
												{
													LifeTime(2.5000)
													Scale(6.0000);
												}
												Color(0)
												{
													LifeTime(0.1250)
													Move(0.0000,0.0000,0.0000,255.0000);
													Next()
													{
														LifeTime(1.7500)
														Move(0.0000,0.0000,0.0000,-255.0000);
													}
												}
											}
											Geometry()
											{
												BlendMode("NORMAL");
												Type("PARTICLE");
												Texture("thicksmoke3");
											}
										}
									}
									ParticleEmitter("Flames")
									{
										MaxParticles(4.0000,4.0000);
										StartDelay(0.0000,0.0000);
										BurstDelay(0.0750, 0.0750);
										BurstCount(1.0000,1.0000);
										MaxLodDist(1000.0000);
										MinLodDist(800.0000);
										BoundingRadius(30.0);
										SoundName("")
										Size(1.0000, 1.0000);
										Hue(255.0000, 255.0000);
										Saturation(255.0000, 255.0000);
										Value(255.0000, 255.0000);
										Alpha(255.0000, 255.0000);
										Spawner()
										{
											Circle()
											{
												PositionX(-2.7000,2.7000);
												PositionY(-2.7000,2.7000);
												PositionZ(-2.7000,2.7000);
											}
											Offset()
											{
												PositionX(-0.2700,0.2700);
												PositionY(-0.2700,0.2700);
												PositionZ(-0.2700,0.2700);
											}
											PositionScale(0.0000,0.0000);
											VelocityScale(2.7000,2.7000);
											InheritVelocityFactor(0.2500,0.2500);
											Size(0, 0.5000, 1.0000);
											Red(0, 255.0000, 255.0000);
											Green(0, 204.0000, 233.0000);
											Blue(0, 98.0000, 185.0000);
											Alpha(0, 0.0000, 128.0000);
											StartRotation(0, 0.0000, 255.0000);
											RotationVelocity(0, -160.0000, 160.0000);
											FadeInTime(0.0000);
										}
										Transformer()
										{
											LifeTime(1.2500);
											Position()
											{
												LifeTime(1.2500)
												Scale(0.0000);
											}
											Size(0)
											{
												LifeTime(0.1250)
												Scale(4.0000);
												Next()
												{
													LifeTime(1.1250)
													Scale(3.0000);
												}
											}
											Color(0)
											{
												LifeTime(0.1250)
												Move(0.0000,-40.0000,-50.0000,128.0000);
												Next()
												{
													LifeTime(0.6250)
													Move(128.0000,-40.0000,-50.0000,-128.0000);
													Next()
													{
														LifeTime(0.5000)
														Move(128.0000,-50.0000,-50.0000,-128.0000);
													}
												}
											}
										}
										Geometry()
										{
											BlendMode("ADDITIVE");
											Type("PARTICLE");
											Texture("com_sfx_explosion1");
											ParticleEmitter("BlackSmoke")
											{
												MaxParticles(3.0000,3.0000);
												StartDelay(0.0000,0.0000);
												BurstDelay(0.0250, 0.0250);
												BurstCount(1.0000,1.0000);
												MaxLodDist(50.0000);
												MinLodDist(10.0000);
												BoundingRadius(5.0);
												SoundName("")
												Size(1.0000, 1.0000);
												Hue(255.0000, 255.0000);
												Saturation(255.0000, 255.0000);
												Value(255.0000, 255.0000);
												Alpha(255.0000, 255.0000);
												Spawner()
												{
													Spread()
													{
														PositionX(-7.0875,7.0875);
														PositionY(-7.0875,7.0875);
														PositionZ(-7.0875,7.0875);
													}
													Offset()
													{
														PositionX(-0.3546,0.3546);
														PositionY(-0.3546,0.3546);
														PositionZ(-0.3546,0.3546);
													}
													PositionScale(0.0000,0.0000);
													VelocityScale(10.1250,10.1250);
													InheritVelocityFactor(0.1000,0.1000);
													Size(0, 1.4175, 2.8350);
													Red(0, 254.0000, 255.0000);
													Green(0, 172.0000, 179.0000);
													Blue(0, 75.0000, 89.0000);
													Alpha(0, 0.0000, 0.0000);
													StartRotation(0, -20.0000, 20.0000);
													RotationVelocity(0, -20.0000, 20.0000);
													FadeInTime(0.0000);
												}
												Transformer()
												{
													LifeTime(1.5625);
													Position()
													{
														LifeTime(1.8750)
														Scale(0.0000);
													}
													Size(0)
													{
														LifeTime(1.5625)
														Scale(5.0000);
													}
													Color(0)
													{
														LifeTime(0.0125)
														Move(0.0000,0.0000,0.0000,48.0000);
														Next()
														{
															LifeTime(1.5500)
															Move(0.0000,0.0000,0.0000,-64.0000);
														}
													}
												}
												Geometry()
												{
													BlendMode("ADDITIVE");
													Type("PARTICLE");
													Texture("thicksmoke3");
												}
											}
										}
									}
								}
							}
							ParticleEmitter("Flare3")
							{
								MaxParticles(5.0000,5.0000);
								StartDelay(0.0000,0.0000);
								BurstDelay(0.0000, 0.0000);
								BurstCount(5.0000,5.0000);
								MaxLodDist(2100.0000);
								MinLodDist(2000.0000);
								BoundingRadius(5.0);
								SoundName("")
								NoRegisterStep();
								Size(1.0000, 1.0000);
								Hue(255.0000, 255.0000);
								Saturation(255.0000, 255.0000);
								Value(255.0000, 255.0000);
								Alpha(255.0000, 255.0000);
								Spawner()
								{
									Spread()
									{
										PositionX(0.0000,0.0000);
										PositionY(0.0000,0.0000);
										PositionZ(0.0000,0.0000);
									}
									Offset()
									{
										PositionX(0.0000,0.0000);
										PositionY(4.0000,4.0000);
										PositionZ(20.0000,20.0000);
									}
									PositionScale(0.0000,0.0000);
									VelocityScale(0.0000,0.0000);
									InheritVelocityFactor(0.0000,0.0000);
									Size(0, 14.0000, 14.0000);
									Red(0, 255.0000, 255.0000);
									Green(0, 240.0000, 240.0000);
									Blue(0, 200.0000, 200.0000);
									Alpha(0, 128.0000, 128.0000);
									StartRotation(0, 1.0000, 1.9000);
									RotationVelocity(0, 0.0000, 0.0000);
									FadeInTime(0.0000);
								}
								Transformer()
								{
									LifeTime(1.2500);
									Position()
									{
										LifeTime(1.2500)
									}
									Size(0)
									{
										LifeTime(0.1250)
									}
									Color(0)
									{
										LifeTime(1.2500)
										Move(0.0000,0.0000,0.0000,-128.0000);
									}
								}
								Geometry()
								{
									BlendMode("ADDITIVE");
									Type("PARTICLE");
									Texture("com_sfx_flashball3");
								}
								ParticleEmitter("Sparks3")
								{
									MaxParticles(10.0000,10.0000);
									StartDelay(0.0000,0.0000);
									BurstDelay(0.0010, 0.0010);
									BurstCount(5.0000,5.0000);
									MaxLodDist(2100.0000);
									MinLodDist(2000.0000);
									BoundingRadius(5.0);
									SoundName("")
									NoRegisterStep();
									Size(1.0000, 1.0000);
									Red(255.0000, 255.0000);
									Green(255.0000, 255.0000);
									Blue(255.0000, 255.0000);
									Alpha(255.0000, 255.0000);
									Spawner()
									{
										Circle()
										{
											PositionX(-1.0000,1.0000);
											PositionY(0.0000,1.5000);
											PositionZ(1.0000,1.5000);
										}
										Offset()
										{
											PositionX(0.0000,0.0000);
											PositionY(0.0000,4.0000);
											PositionZ(20.0000,20.0000);
										}
										PositionScale(1.5000,4.5000);
										VelocityScale(3.0000,33.0000);
										InheritVelocityFactor(0.0000,0.0000);
										Size(0, 0.0375, 0.0750);
										Red(0, 255.0000, 255.0000);
										Green(0, 255.0000, 255.0000);
										Blue(0, 255.0000, 255.0000);
										Alpha(0, 255.0000, 255.0000);
										StartRotation(0, 0.0000, 360.0000);
										RotationVelocity(0, -100.0000, 100.0000);
										FadeInTime(0.0000);
									}
									Transformer()
									{
										LifeTime(2.5000);
										Position()
										{
											LifeTime(2.5000)
											Accelerate(0.0000, -45.0000, 0.0000);
										}
										Size(0)
										{
											LifeTime(2.5000)
											Scale(0.0000);
										}
										Color(0)
										{
											LifeTime(2.5000)
											Move(0.0000,0.0000,0.0000,-255.0000);
										}
									}
									Geometry()
									{
										BlendMode("ADDITIVE");
										Type("SPARK");
										SparkLength(0.0500);
										Texture("com_sfx_laser_orange");
									}
									ParticleEmitter("Explosion4")
									{
										MaxParticles(4.0000,4.0000);
										StartDelay(0.0000,0.0000);
										BurstDelay(0.0010, 0.0010);
										BurstCount(4.0000,4.0000);
										MaxLodDist(2100.0000);
										MinLodDist(2000.0000);
										BoundingRadius(30.0);
										SoundName("")
										NoRegisterStep();
										Size(1.0000, 1.0000);
										Hue(255.0000, 255.0000);
										Saturation(255.0000, 255.0000);
										Value(255.0000, 255.0000);
										Alpha(255.0000, 255.0000);
										Spawner()
										{
											Circle()
											{
												PositionX(-1.0000,1.0000);
												PositionY(0.5000,1.0000);
												PositionZ(-5.0000,-1.0000);
											}
											Offset()
											{
												PositionX(0.0000,0.0000);
												PositionY(0.0000,4.0000);
												PositionZ(-20.0000,-20.0000);
											}
											PositionScale(1.5000,1.5000);
											VelocityScale(20.0000,35.0000);
											InheritVelocityFactor(0.0000,0.0000);
											Size(0, 2.7000, 5.4000);
											Red(0, 255.0000, 255.0000);
											Green(0, 255.0000, 255.0000);
											Blue(0, 255.0000, 255.0000);
											Alpha(0, 255.0000, 255.0000);
											StartRotation(0, 0.0000, 360.0000);
											RotationVelocity(0, -100.0000, 100.0000);
											FadeInTime(0.0000);
										}
										Transformer()
										{
											LifeTime(2.5000);
											Position()
											{
												LifeTime(1.2500)
											}
											Size(0)
											{
												LifeTime(1.8750)
											}
											Color(0)
											{
												LifeTime(1.8750)
												Reach(255.0000,255.0000,255.0000,255.0000);
											}
										}
										Geometry()
										{
											BlendMode("NORMAL");
											Type("EMITTER");
											Texture("explode3");
											ParticleEmitter("Smoke")
											{
												MaxParticles(4.0000,4.0000);
												StartDelay(0.0000,0.0000);
												BurstDelay(0.0750, 0.0750);
												BurstCount(1.0000,1.0000);
												MaxLodDist(1000.0000);
												MinLodDist(800.0000);
												BoundingRadius(30.0);
												SoundName("")
												Size(1.0000, 1.0000);
												Hue(255.0000, 255.0000);
												Saturation(255.0000, 255.0000);
												Value(255.0000, 255.0000);
												Alpha(255.0000, 255.0000);
												Spawner()
												{
													Circle()
													{
														PositionX(-2.7000,2.7000);
														PositionY(-2.7000,2.7000);
														PositionZ(-2.7000,2.7000);
													}
													Offset()
													{
														PositionX(0.0000,0.0000);
														PositionY(0.0000,0.0000);
														PositionZ(0.0000,0.0000);
													}
													PositionScale(0.0000,0.0000);
													VelocityScale(1.3500,1.3500);
													InheritVelocityFactor(0.2500,0.2500);
													Size(0, 2.0000, 3.5000);
													Hue(0, 0.0000, 0.0000);
													Saturation(0, 0.0000, 0.0000);
													Value(0, 150.0000, 255.0000);
													Alpha(0, 0.0000, 128.0000);
													StartRotation(0, 0.0000, 360.0000);
													RotationVelocity(0, -90.0000, 90.0000);
													FadeInTime(0.0000);
												}
												Transformer()
												{
													LifeTime(1.8750);
													Position()
													{
														LifeTime(1.8750)
														Scale(0.0000);
													}
													Size(0)
													{
														LifeTime(0.3125)
														Scale(2.5000);
														Next()
														{
															LifeTime(1.5625)
															Scale(2.5000);
														}
													}
													Color(0)
													{
														LifeTime(0.1250)
														Move(0.0000,0.0000,0.0000,128.0000);
														Next()
														{
															LifeTime(1.7500)
															Move(0.0000,0.0000,-128.0000,-255.0000);
														}
													}
												}
												Geometry()
												{
													BlendMode("NORMAL");
													Type("PARTICLE");
													Texture("com_sfx_smoke1");
													ParticleEmitter("BlackSmoke")
													{
														MaxParticles(4.0000,4.0000);
														StartDelay(0.0000,0.0000);
														BurstDelay(0.0250, 0.0250);
														BurstCount(1.0000,1.0000);
														MaxLodDist(50.0000);
														MinLodDist(10.0000);
														BoundingRadius(5.0);
														SoundName("")
														Size(1.0000, 1.0000);
														Hue(255.0000, 255.0000);
														Saturation(255.0000, 255.0000);
														Value(255.0000, 255.0000);
														Alpha(255.0000, 255.0000);
														Spawner()
														{
															Spread()
															{
																PositionX(-7.0875,7.0875);
																PositionY(-7.0875,7.0875);
																PositionZ(-7.0875,7.0875);
															}
															Offset()
															{
																PositionX(-0.3546,0.3546);
																PositionY(-0.3546,0.3546);
																PositionZ(-0.3546,0.3546);
															}
															PositionScale(0.0000,0.0000);
															VelocityScale(7.0875,7.0875);
															InheritVelocityFactor(0.2000,0.2000);
															Size(0, 3.5439, 4.9614);
															Hue(0, 12.0000, 20.0000);
															Saturation(0, 5.0000, 10.0000);
															Value(0, 200.0000, 220.0000);
															Alpha(0, 0.0000, 0.0000);
															StartRotation(0, -20.0000, 20.0000);
															RotationVelocity(0, -20.0000, 20.0000);
															FadeInTime(0.0000);
														}
														Transformer()
														{
															LifeTime(1.8750);
															Position()
															{
																LifeTime(1.8750)
																Scale(0.0000);
															}
															Size(0)
															{
																LifeTime(2.5000)
																Scale(6.0000);
															}
															Color(0)
															{
																LifeTime(0.1250)
																Move(0.0000,0.0000,0.0000,255.0000);
																Next()
																{
																	LifeTime(1.7500)
																	Move(0.0000,0.0000,0.0000,-255.0000);
																}
															}
														}
														Geometry()
														{
															BlendMode("NORMAL");
															Type("PARTICLE");
															Texture("thicksmoke3");
														}
													}
												}
												ParticleEmitter("Flames")
												{
													MaxParticles(4.0000,4.0000);
													StartDelay(0.0000,0.0000);
													BurstDelay(0.0750, 0.0750);
													BurstCount(1.0000,1.0000);
													MaxLodDist(1000.0000);
													MinLodDist(800.0000);
													BoundingRadius(30.0);
													SoundName("")
													Size(1.0000, 1.0000);
													Hue(255.0000, 255.0000);
													Saturation(255.0000, 255.0000);
													Value(255.0000, 255.0000);
													Alpha(255.0000, 255.0000);
													Spawner()
													{
														Circle()
														{
															PositionX(-2.7000,2.7000);
															PositionY(-2.7000,2.7000);
															PositionZ(-2.7000,2.7000);
														}
														Offset()
														{
															PositionX(-0.2700,0.2700);
															PositionY(-0.2700,0.2700);
															PositionZ(-0.2700,0.2700);
														}
														PositionScale(0.0000,0.0000);
														VelocityScale(2.7000,2.7000);
														InheritVelocityFactor(0.2500,0.2500);
														Size(0, 0.5000, 1.0000);
														Red(0, 255.0000, 255.0000);
														Green(0, 204.0000, 233.0000);
														Blue(0, 98.0000, 185.0000);
														Alpha(0, 0.0000, 128.0000);
														StartRotation(0, 0.0000, 255.0000);
														RotationVelocity(0, -160.0000, 160.0000);
														FadeInTime(0.0000);
													}
													Transformer()
													{
														LifeTime(1.2500);
														Position()
														{
															LifeTime(1.2500)
															Scale(0.0000);
														}
														Size(0)
														{
															LifeTime(0.1250)
															Scale(4.0000);
															Next()
															{
																LifeTime(1.1250)
																Scale(3.0000);
															}
														}
														Color(0)
														{
															LifeTime(0.1250)
															Move(0.0000,-40.0000,-50.0000,128.0000);
															Next()
															{
																LifeTime(0.6250)
																Move(128.0000,-40.0000,-50.0000,-128.0000);
																Next()
																{
																	LifeTime(0.5000)
																	Move(128.0000,-50.0000,-50.0000,-128.0000);
																}
															}
														}
													}
													Geometry()
													{
														BlendMode("ADDITIVE");
														Type("PARTICLE");
														Texture("com_sfx_explosion1");
														ParticleEmitter("BlackSmoke")
														{
															MaxParticles(3.0000,3.0000);
															StartDelay(0.0000,0.0000);
															BurstDelay(0.0250, 0.0250);
															BurstCount(1.0000,1.0000);
															MaxLodDist(50.0000);
															MinLodDist(10.0000);
															BoundingRadius(5.0);
															SoundName("")
															Size(1.0000, 1.0000);
															Hue(255.0000, 255.0000);
															Saturation(255.0000, 255.0000);
															Value(255.0000, 255.0000);
															Alpha(255.0000, 255.0000);
															Spawner()
															{
																Spread()
																{
																	PositionX(-7.0875,7.0875);
																	PositionY(-7.0875,7.0875);
																	PositionZ(-7.0875,7.0875);
																}
																Offset()
																{
																	PositionX(-0.3546,0.3546);
																	PositionY(-0.3546,0.3546);
																	PositionZ(-0.3546,0.3546);
																}
																PositionScale(0.0000,0.0000);
																VelocityScale(10.1250,10.1250);
																InheritVelocityFactor(0.1000,0.1000);
																Size(0, 1.4175, 2.8350);
																Red(0, 254.0000, 255.0000);
																Green(0, 172.0000, 179.0000);
																Blue(0, 75.0000, 89.0000);
																Alpha(0, 0.0000, 0.0000);
																StartRotation(0, -20.0000, 20.0000);
																RotationVelocity(0, -20.0000, 20.0000);
																FadeInTime(0.0000);
															}
															Transformer()
															{
																LifeTime(1.5625);
																Position()
																{
																	LifeTime(1.8750)
																	Scale(0.0000);
																}
																Size(0)
																{
																	LifeTime(1.5625)
																	Scale(5.0000);
																}
																Color(0)
																{
																	LifeTime(0.0125)
																	Move(0.0000,0.0000,0.0000,48.0000);
																	Next()
																	{
																		LifeTime(1.5500)
																		Move(0.0000,0.0000,0.0000,-64.0000);
																	}
																}
															}
															Geometry()
															{
																BlendMode("ADDITIVE");
																Type("PARTICLE");
																Texture("thicksmoke3");
															}
														}
													}
												}
											}
										}
										ParticleEmitter("Flare4")
										{
											MaxParticles(5.0000,5.0000);
											StartDelay(0.0000,0.0000);
											BurstDelay(0.0000, 0.0000);
											BurstCount(5.0000,5.0000);
											MaxLodDist(2100.0000);
											MinLodDist(2000.0000);
											BoundingRadius(5.0);
											SoundName("")
											NoRegisterStep();
											Size(1.0000, 1.0000);
											Hue(255.0000, 255.0000);
											Saturation(255.0000, 255.0000);
											Value(255.0000, 255.0000);
											Alpha(255.0000, 255.0000);
											Spawner()
											{
												Spread()
												{
													PositionX(0.0000,0.0000);
													PositionY(0.0000,0.0000);
													PositionZ(0.0000,0.0000);
												}
												Offset()
												{
													PositionX(0.0000,0.0000);
													PositionY(4.0000,4.0000);
													PositionZ(-20.0000,-20.0000);
												}
												PositionScale(0.0000,0.0000);
												VelocityScale(0.0000,0.0000);
												InheritVelocityFactor(0.0000,0.0000);
												Size(0, 14.0000, 14.0000);
												Red(0, 255.0000, 255.0000);
												Green(0, 240.0000, 240.0000);
												Blue(0, 200.0000, 200.0000);
												Alpha(0, 128.0000, 128.0000);
												StartRotation(0, 1.0000, 1.9000);
												RotationVelocity(0, 0.0000, 0.0000);
												FadeInTime(0.0000);
											}
											Transformer()
											{
												LifeTime(1.2500);
												Position()
												{
													LifeTime(1.2500)
												}
												Size(0)
												{
													LifeTime(0.1250)
												}
												Color(0)
												{
													LifeTime(1.2500)
													Move(0.0000,0.0000,0.0000,-128.0000);
												}
											}
											Geometry()
											{
												BlendMode("ADDITIVE");
												Type("PARTICLE");
												Texture("com_sfx_flashball3");
											}
											ParticleEmitter("Sparks4")
											{
												MaxParticles(10.0000,10.0000);
												StartDelay(0.0000,0.0000);
												BurstDelay(0.0010, 0.0010);
												BurstCount(5.0000,5.0000);
												MaxLodDist(2100.0000);
												MinLodDist(2000.0000);
												BoundingRadius(5.0);
												SoundName("")
												NoRegisterStep();
												Size(1.0000, 1.0000);
												Red(255.0000, 255.0000);
												Green(255.0000, 255.0000);
												Blue(255.0000, 255.0000);
												Alpha(255.0000, 255.0000);
												Spawner()
												{
													Circle()
													{
														PositionX(-1.0000,1.0000);
														PositionY(0.0000,1.5000);
														PositionZ(-1.5000,-1.0000);
													}
													Offset()
													{
														PositionX(0.0000,0.0000);
														PositionY(0.0000,4.0000);
														PositionZ(-20.0000,-20.0000);
													}
													PositionScale(1.5000,4.5000);
													VelocityScale(3.0000,33.0000);
													InheritVelocityFactor(0.0000,0.0000);
													Size(0, 0.0375, 0.0750);
													Red(0, 255.0000, 255.0000);
													Green(0, 255.0000, 255.0000);
													Blue(0, 255.0000, 255.0000);
													Alpha(0, 255.0000, 255.0000);
													StartRotation(0, 0.0000, 360.0000);
													RotationVelocity(0, -100.0000, 100.0000);
													FadeInTime(0.0000);
												}
												Transformer()
												{
													LifeTime(2.5000);
													Position()
													{
														LifeTime(2.5000)
														Accelerate(0.0000, -45.0000, 0.0000);
													}
													Size(0)
													{
														LifeTime(2.5000)
														Scale(0.0000);
													}
													Color(0)
													{
														LifeTime(2.5000)
														Move(0.0000,0.0000,0.0000,-255.0000);
													}
												}
												Geometry()
												{
													BlendMode("ADDITIVE");
													Type("SPARK");
													SparkLength(0.0500);
													Texture("com_sfx_laser_orange");
												}
												ParticleEmitter("Explosion")
												{
													MaxParticles(6.0000,6.0000);
													StartDelay(0.0000,0.0000);
													BurstDelay(0.0010, 0.0010);
													BurstCount(6.0000,6.0000);
													MaxLodDist(2100.0000);
													MinLodDist(2000.0000);
													BoundingRadius(30.0);
													SoundName("")
													NoRegisterStep();
													Size(1.0000, 1.0000);
													Hue(255.0000, 255.0000);
													Saturation(255.0000, 255.0000);
													Value(255.0000, 255.0000);
													Alpha(255.0000, 255.0000);
													Spawner()
													{
														Circle()
														{
															PositionX(-2.0000,2.0000);
															PositionY(0.2500,0.2500);
															PositionZ(-2.0000,2.0000);
														}
														Offset()
														{
															PositionX(0.0000,0.0000);
															PositionY(4.0000,4.0000);
															PositionZ(0.0000,0.0000);
														}
														PositionScale(1.5000,1.5000);
														VelocityScale(7.5000,22.5000);
														InheritVelocityFactor(0.0000,0.0000);
														Size(0, 2.7000, 5.4000);
														Red(0, 255.0000, 255.0000);
														Green(0, 255.0000, 255.0000);
														Blue(0, 255.0000, 255.0000);
														Alpha(0, 255.0000, 255.0000);
														StartRotation(0, 0.0000, 360.0000);
														RotationVelocity(0, -100.0000, 100.0000);
														FadeInTime(0.0000);
													}
													Transformer()
													{
														LifeTime(2.5000);
														Position()
														{
															LifeTime(1.2500)
														}
														Size(0)
														{
															LifeTime(1.8750)
														}
														Color(0)
														{
															LifeTime(1.8750)
															Reach(255.0000,255.0000,255.0000,255.0000);
														}
													}
													Geometry()
													{
														BlendMode("NORMAL");
														Type("EMITTER");
														Texture("explode3");
														ParticleEmitter("Smoke")
														{
															MaxParticles(4.0000,4.0000);
															StartDelay(0.0000,0.0000);
															BurstDelay(0.0750, 0.0750);
															BurstCount(1.0000,1.0000);
															MaxLodDist(1000.0000);
															MinLodDist(800.0000);
															BoundingRadius(30.0);
															SoundName("")
															Size(1.0000, 1.0000);
															Hue(255.0000, 255.0000);
															Saturation(255.0000, 255.0000);
															Value(255.0000, 255.0000);
															Alpha(255.0000, 255.0000);
															Spawner()
															{
																Circle()
																{
																	PositionX(-2.7000,2.7000);
																	PositionY(-2.7000,2.7000);
																	PositionZ(-2.7000,2.7000);
																}
																Offset()
																{
																	PositionX(0.0000,0.0000);
																	PositionY(0.0000,0.0000);
																	PositionZ(0.0000,0.0000);
																}
																PositionScale(0.0000,0.0000);
																VelocityScale(1.3500,1.3500);
																InheritVelocityFactor(0.2500,0.2500);
																Size(0, 1.0500, 1.8000);
																Hue(0, 0.0000, 0.0000);
																Saturation(0, 0.0000, 0.0000);
																Value(0, 150.0000, 255.0000);
																Alpha(0, 0.0000, 128.0000);
																StartRotation(0, 0.0000, 360.0000);
																RotationVelocity(0, -90.0000, 90.0000);
																FadeInTime(0.0000);
															}
															Transformer()
															{
																LifeTime(1.8750);
																Position()
																{
																	LifeTime(1.8750)
																	Scale(0.0000);
																}
																Size(0)
																{
																	LifeTime(0.3125)
																	Scale(2.5000);
																	Next()
																	{
																		LifeTime(1.5625)
																		Scale(2.5000);
																	}
																}
																Color(0)
																{
																	LifeTime(0.1250)
																	Move(0.0000,0.0000,0.0000,128.0000);
																	Next()
																	{
																		LifeTime(1.7500)
																		Move(0.0000,0.0000,-128.0000,-255.0000);
																	}
																}
															}
															Geometry()
															{
																BlendMode("NORMAL");
																Type("PARTICLE");
																Texture("com_sfx_smoke1");
																ParticleEmitter("BlackSmoke")
																{
																	MaxParticles(4.0000,4.0000);
																	StartDelay(0.0000,0.0000);
																	BurstDelay(0.0250, 0.0250);
																	BurstCount(1.0000,1.0000);
																	MaxLodDist(50.0000);
																	MinLodDist(10.0000);
																	BoundingRadius(5.0);
																	SoundName("")
																	Size(1.0000, 1.0000);
																	Hue(255.0000, 255.0000);
																	Saturation(255.0000, 255.0000);
																	Value(255.0000, 255.0000);
																	Alpha(255.0000, 255.0000);
																	Spawner()
																	{
																		Spread()
																		{
																			PositionX(-7.0875,7.0875);
																			PositionY(-7.0875,7.0875);
																			PositionZ(-7.0875,7.0875);
																		}
																		Offset()
																		{
																			PositionX(-0.3546,0.3546);
																			PositionY(-0.3546,0.3546);
																			PositionZ(-0.3546,0.3546);
																		}
																		PositionScale(0.0000,0.0000);
																		VelocityScale(7.0875,7.0875);
																		InheritVelocityFactor(0.2000,0.2000);
																		Size(0, 3.5439, 4.9614);
																		Hue(0, 12.0000, 20.0000);
																		Saturation(0, 5.0000, 10.0000);
																		Value(0, 200.0000, 220.0000);
																		Alpha(0, 0.0000, 0.0000);
																		StartRotation(0, -20.0000, 20.0000);
																		RotationVelocity(0, -20.0000, 20.0000);
																		FadeInTime(0.0000);
																	}
																	Transformer()
																	{
																		LifeTime(1.8750);
																		Position()
																		{
																			LifeTime(1.8750)
																			Scale(0.0000);
																		}
																		Size(0)
																		{
																			LifeTime(2.5000)
																			Scale(6.0000);
																		}
																		Color(0)
																		{
																			LifeTime(0.1250)
																			Move(0.0000,0.0000,0.0000,255.0000);
																			Next()
																			{
																				LifeTime(1.7500)
																				Move(0.0000,0.0000,0.0000,-255.0000);
																			}
																		}
																	}
																	Geometry()
																	{
																		BlendMode("NORMAL");
																		Type("PARTICLE");
																		Texture("thicksmoke3");
																	}
																}
															}
															ParticleEmitter("Flames")
															{
																MaxParticles(4.0000,4.0000);
																StartDelay(0.0000,0.0000);
																BurstDelay(0.0750, 0.0750);
																BurstCount(1.0000,1.0000);
																MaxLodDist(1000.0000);
																MinLodDist(800.0000);
																BoundingRadius(30.0);
																SoundName("")
																Size(1.0000, 1.0000);
																Hue(255.0000, 255.0000);
																Saturation(255.0000, 255.0000);
																Value(255.0000, 255.0000);
																Alpha(255.0000, 255.0000);
																Spawner()
																{
																	Circle()
																	{
																		PositionX(-2.7000,2.7000);
																		PositionY(-2.7000,2.7000);
																		PositionZ(-2.7000,2.7000);
																	}
																	Offset()
																	{
																		PositionX(-0.2700,0.2700);
																		PositionY(-0.2700,0.2700);
																		PositionZ(-0.2700,0.2700);
																	}
																	PositionScale(0.0000,0.0000);
																	VelocityScale(2.7000,2.7000);
																	InheritVelocityFactor(0.2500,0.2500);
																	Size(0, 0.2700, 0.5400);
																	Red(0, 255.0000, 255.0000);
																	Green(0, 204.0000, 233.0000);
																	Blue(0, 98.0000, 185.0000);
																	Alpha(0, 0.0000, 128.0000);
																	StartRotation(0, 0.0000, 255.0000);
																	RotationVelocity(0, -160.0000, 160.0000);
																	FadeInTime(0.0000);
																}
																Transformer()
																{
																	LifeTime(1.2500);
																	Position()
																	{
																		LifeTime(1.2500)
																		Scale(0.0000);
																	}
																	Size(0)
																	{
																		LifeTime(0.1250)
																		Scale(4.0000);
																		Next()
																		{
																			LifeTime(1.1250)
																			Scale(3.0000);
																		}
																	}
																	Color(0)
																	{
																		LifeTime(0.1250)
																		Move(0.0000,-40.0000,-50.0000,128.0000);
																		Next()
																		{
																			LifeTime(0.6250)
																			Move(128.0000,-40.0000,-50.0000,-128.0000);
																			Next()
																			{
																				LifeTime(0.5000)
																				Move(128.0000,-50.0000,-50.0000,-128.0000);
																			}
																		}
																	}
																}
																Geometry()
																{
																	BlendMode("ADDITIVE");
																	Type("PARTICLE");
																	Texture("com_sfx_explosion1");
																	ParticleEmitter("BlackSmoke")
																	{
																		MaxParticles(3.0000,3.0000);
																		StartDelay(0.0000,0.0000);
																		BurstDelay(0.0250, 0.0250);
																		BurstCount(1.0000,1.0000);
																		MaxLodDist(50.0000);
																		MinLodDist(10.0000);
																		BoundingRadius(5.0);
																		SoundName("")
																		Size(1.0000, 1.0000);
																		Hue(255.0000, 255.0000);
																		Saturation(255.0000, 255.0000);
																		Value(255.0000, 255.0000);
																		Alpha(255.0000, 255.0000);
																		Spawner()
																		{
																			Spread()
																			{
																				PositionX(-7.0875,7.0875);
																				PositionY(-7.0875,7.0875);
																				PositionZ(-7.0875,7.0875);
																			}
																			Offset()
																			{
																				PositionX(-0.3546,0.3546);
																				PositionY(-0.3546,0.3546);
																				PositionZ(-0.3546,0.3546);
																			}
																			PositionScale(0.0000,0.0000);
																			VelocityScale(10.1250,10.1250);
																			InheritVelocityFactor(0.1000,0.1000);
																			Size(0, 1.4175, 2.8350);
																			Red(0, 254.0000, 255.0000);
																			Green(0, 172.0000, 179.0000);
																			Blue(0, 75.0000, 89.0000);
																			Alpha(0, 0.0000, 0.0000);
																			StartRotation(0, -20.0000, 20.0000);
																			RotationVelocity(0, -20.0000, 20.0000);
																			FadeInTime(0.0000);
																		}
																		Transformer()
																		{
																			LifeTime(1.5625);
																			Position()
																			{
																				LifeTime(1.8750)
																				Scale(0.0000);
																			}
																			Size(0)
																			{
																				LifeTime(1.5625)
																				Scale(5.0000);
																			}
																			Color(0)
																			{
																				LifeTime(0.0125)
																				Move(0.0000,0.0000,0.0000,48.0000);
																				Next()
																				{
																					LifeTime(1.5500)
																					Move(0.0000,0.0000,0.0000,-64.0000);
																				}
																			}
																		}
																		Geometry()
																		{
																			BlendMode("ADDITIVE");
																			Type("PARTICLE");
																			Texture("thicksmoke3");
																		}
																	}
																}
															}
														}
													}
													ParticleEmitter("Flare")
													{
														MaxParticles(5.0000,5.0000);
														StartDelay(0.0000,0.0000);
														BurstDelay(0.0000, 0.0000);
														BurstCount(5.0000,5.0000);
														MaxLodDist(2100.0000);
														MinLodDist(2000.0000);
														BoundingRadius(5.0);
														SoundName("")
														NoRegisterStep();
														Size(1.0000, 1.0000);
														Hue(255.0000, 255.0000);
														Saturation(255.0000, 255.0000);
														Value(255.0000, 255.0000);
														Alpha(255.0000, 255.0000);
														Spawner()
														{
															Spread()
															{
																PositionX(0.0000,0.0000);
																PositionY(0.0000,0.0000);
																PositionZ(0.0000,0.0000);
															}
															Offset()
															{
																PositionX(0.0000,0.0000);
																PositionY(4.0000,4.0000);
																PositionZ(0.0000,0.0000);
															}
															PositionScale(0.0000,0.0000);
															VelocityScale(0.0000,0.0000);
															InheritVelocityFactor(0.0000,0.0000);
															Size(0, 7.5000, 7.5000);
															Red(0, 255.0000, 255.0000);
															Green(0, 240.0000, 240.0000);
															Blue(0, 200.0000, 200.0000);
															Alpha(0, 128.0000, 128.0000);
															StartRotation(0, 1.0000, 1.9000);
															RotationVelocity(0, 0.0000, 0.0000);
															FadeInTime(0.0000);
														}
														Transformer()
														{
															LifeTime(1.2500);
															Position()
															{
																LifeTime(1.2500)
															}
															Size(0)
															{
																LifeTime(0.1250)
															}
															Color(0)
															{
																LifeTime(1.2500)
																Move(0.0000,0.0000,0.0000,-128.0000);
															}
														}
														Geometry()
														{
															BlendMode("ADDITIVE");
															Type("BILLBOARD");
															Texture("com_sfx_flashball3");
														}
														ParticleEmitter("Embers")
														{
															MaxParticles(10.0000,10.0000);
															StartDelay(0.0000,0.0000);
															BurstDelay(0.0010, 0.0010);
															BurstCount(10.0000,10.0000);
															MaxLodDist(2100.0000);
															MinLodDist(2000.0000);
															BoundingRadius(5.0);
															SoundName("")
															NoRegisterStep();
															Size(1.0000, 1.0000);
															Hue(255.0000, 255.0000);
															Saturation(255.0000, 255.0000);
															Value(255.0000, 255.0000);
															Alpha(255.0000, 255.0000);
															Spawner()
															{
																Circle()
																{
																	PositionX(-0.7500,0.7500);
																	PositionY(0.7500,3.0000);
																	PositionZ(-0.7500,0.7500);
																}
																Offset()
																{
																	PositionX(0.0000,0.0000);
																	PositionY(4.0000,4.0000);
																	PositionZ(0.0000,0.0000);
																}
																PositionScale(1.5000,1.5000);
																VelocityScale(6.0000,10.5000);
																InheritVelocityFactor(0.0000,0.0000);
																Size(0, 1.5000, 4.5000);
																Red(0, 255.0000, 255.0000);
																Green(0, 143.0000, 143.0000);
																Blue(0, 89.0000, 89.0000);
																Alpha(0, 255.0000, 255.0000);
																StartRotation(0, 0.0000, 360.0000);
																RotationVelocity(0, -90.0000, 90.0000);
																FadeInTime(0.0000);
															}
															Transformer()
															{
																LifeTime(1.2500);
																Position()
																{
																	LifeTime(1.2500)
																	Accelerate(0.0000, -15.0000, 0.0000);
																}
																Size(0)
																{
																	LifeTime(1.2500)
																	Scale(1.5000);
																}
																Color(0)
																{
																	LifeTime(1.2500)
																	Move(0.0000,-100.0000,-100.0000,-255.0000);
																}
															}
															Geometry()
															{
																BlendMode("ADDITIVE");
																Type("PARTICLE");
																Texture("com_sfx_dirt1");
															}
															ParticleEmitter("Sparks")
															{
																MaxParticles(10.0000,10.0000);
																StartDelay(0.0000,0.0000);
																BurstDelay(0.0010, 0.0010);
																BurstCount(5.0000,5.0000);
																MaxLodDist(2100.0000);
																MinLodDist(2000.0000);
																BoundingRadius(5.0);
																SoundName("")
																NoRegisterStep();
																Size(1.0000, 1.0000);
																Red(255.0000, 255.0000);
																Green(255.0000, 255.0000);
																Blue(255.0000, 255.0000);
																Alpha(255.0000, 255.0000);
																Spawner()
																{
																	Circle()
																	{
																		PositionX(-1.5000,1.5000);
																		PositionY(0.0000,1.5000);
																		PositionZ(-1.5000,1.5000);
																	}
																	Offset()
																	{
																		PositionX(0.0000,0.0000);
																		PositionY(4.0000,4.0000);
																		PositionZ(0.0000,0.0000);
																	}
																	PositionScale(1.5000,4.5000);
																	VelocityScale(3.0000,33.0000);
																	InheritVelocityFactor(0.0000,0.0000);
																	Size(0, 0.0375, 0.0750);
																	Red(0, 255.0000, 255.0000);
																	Green(0, 255.0000, 255.0000);
																	Blue(0, 255.0000, 255.0000);
																	Alpha(0, 255.0000, 255.0000);
																	StartRotation(0, 0.0000, 360.0000);
																	RotationVelocity(0, -100.0000, 100.0000);
																	FadeInTime(0.0000);
																}
																Transformer()
																{
																	LifeTime(2.5000);
																	Position()
																	{
																		LifeTime(2.5000)
																		Accelerate(0.0000, -45.0000, 0.0000);
																	}
																	Size(0)
																	{
																		LifeTime(2.5000)
																		Scale(0.0000);
																	}
																	Color(0)
																	{
																		LifeTime(2.5000)
																		Move(0.0000,0.0000,0.0000,-255.0000);
																	}
																}
																Geometry()
																{
																	BlendMode("ADDITIVE");
																	Type("SPARK");
																	SparkLength(0.0500);
																	Texture("com_sfx_laser_orange");
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
