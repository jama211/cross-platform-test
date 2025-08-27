using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System.Collections.Generic;

namespace SimplePlatformer;

public class Platformer : Game
{
    private GraphicsDeviceManager _graphics;
    private SpriteBatch _spriteBatch;
    private Texture2D _pixelTexture;
    
    // Player
    private Vector2 _playerPosition = new Vector2(100, 300);
    private Vector2 _playerVelocity = Vector2.Zero;
    private Rectangle _playerRect => new Rectangle((int)_playerPosition.X, (int)_playerPosition.Y, 32, 48);
    
    // Game constants
    private const float Gravity = 0.8f;
    private const float JumpStrength = -15f;
    private const float MoveSpeed = 5f;
    private const float MaxFallSpeed = 20f;
    
    // Platforms
    private List<Rectangle> _platforms;
    private bool _isOnGround = false;

    public Platformer()
    {
        _graphics = new GraphicsDeviceManager(this);
        Content.RootDirectory = "Content";
        IsMouseVisible = true;
        
        // Set window size
        _graphics.PreferredBackBufferWidth = 1280;
        _graphics.PreferredBackBufferHeight = 720;
    }

    protected override void Initialize()
    {
        // Create platforms
        _platforms = new List<Rectangle>
        {
            // Ground
            new Rectangle(0, 600, 1280, 120),
            // Platforms
            new Rectangle(200, 500, 200, 32),
            new Rectangle(500, 400, 200, 32),
            new Rectangle(800, 300, 200, 32),
            new Rectangle(300, 200, 200, 32),
            new Rectangle(600, 150, 200, 32),
        };

        base.Initialize();
    }

    protected override void LoadContent()
    {
        _spriteBatch = new SpriteBatch(GraphicsDevice);
        
        // Create a 1x1 white pixel texture for drawing rectangles
        _pixelTexture = new Texture2D(GraphicsDevice, 1, 1);
        _pixelTexture.SetData(new[] { Color.White });
    }

    protected override void Update(GameTime gameTime)
    {
        if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || 
            Keyboard.GetState().IsKeyDown(Keys.Escape))
            Exit();

        var keyboardState = Keyboard.GetState();
        
        // Horizontal movement
        _playerVelocity.X = 0;
        if (keyboardState.IsKeyDown(Keys.Left) || keyboardState.IsKeyDown(Keys.A))
            _playerVelocity.X = -MoveSpeed;
        if (keyboardState.IsKeyDown(Keys.Right) || keyboardState.IsKeyDown(Keys.D))
            _playerVelocity.X = MoveSpeed;
        
        // Jumping
        if ((keyboardState.IsKeyDown(Keys.Space) || keyboardState.IsKeyDown(Keys.Up) || keyboardState.IsKeyDown(Keys.W)) && _isOnGround)
            _playerVelocity.Y = JumpStrength;
        
        // Apply gravity
        _playerVelocity.Y += Gravity;
        if (_playerVelocity.Y > MaxFallSpeed)
            _playerVelocity.Y = MaxFallSpeed;
        
        // Update position
        _playerPosition += _playerVelocity;
        
        // Collision detection and response
        HandleCollisions();
        
        // Keep player in bounds horizontally
        if (_playerPosition.X < 0)
            _playerPosition.X = 0;
        if (_playerPosition.X > _graphics.PreferredBackBufferWidth - _playerRect.Width)
            _playerPosition.X = _graphics.PreferredBackBufferWidth - _playerRect.Width;
        
        // Reset if player falls off screen
        if (_playerPosition.Y > _graphics.PreferredBackBufferHeight)
        {
            _playerPosition = new Vector2(100, 300);
            _playerVelocity = Vector2.Zero;
        }

        base.Update(gameTime);
    }
    
    private void HandleCollisions()
    {
        _isOnGround = false;
        var playerRect = _playerRect;
        
        foreach (var platform in _platforms)
        {
            if (playerRect.Intersects(platform))
            {
                // Calculate overlap
                var overlapX = System.Math.Min(playerRect.Right - platform.Left, platform.Right - playerRect.Left);
                var overlapY = System.Math.Min(playerRect.Bottom - platform.Top, platform.Bottom - playerRect.Top);
                
                // Resolve collision based on smallest overlap
                if (overlapX < overlapY)
                {
                    // Horizontal collision
                    if (_playerVelocity.X > 0) // Moving right
                        _playerPosition.X = platform.Left - playerRect.Width;
                    else // Moving left
                        _playerPosition.X = platform.Right;
                    _playerVelocity.X = 0;
                }
                else
                {
                    // Vertical collision
                    if (_playerVelocity.Y > 0) // Falling
                    {
                        _playerPosition.Y = platform.Top - playerRect.Height;
                        _playerVelocity.Y = 0;
                        _isOnGround = true;
                    }
                    else // Moving up
                    {
                        _playerPosition.Y = platform.Bottom;
                        _playerVelocity.Y = 0;
                    }
                }
            }
        }
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.CornflowerBlue);
        
        _spriteBatch.Begin();
        
        // Draw platforms
        foreach (var platform in _platforms)
        {
            _spriteBatch.Draw(_pixelTexture, platform, Color.Green);
        }
        
        // Draw player
        _spriteBatch.Draw(_pixelTexture, _playerRect, Color.Red);
        
        _spriteBatch.End();

        base.Draw(gameTime);
    }
}
