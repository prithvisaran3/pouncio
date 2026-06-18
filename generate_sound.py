import math
import struct
import wave

def generate_chime(filename, duration=0.3, sample_rate=44100):
    with wave.open(filename, 'w') as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(sample_rate)
        
        num_frames = int(duration * sample_rate)
        for i in range(num_frames):
            t = i / sample_rate
            # Rising sweep from 500Hz to 1100Hz
            f0 = 500.0
            f1 = 1100.0
            freq = f0 + (f1 - f0) * (t / duration)
            phase = 2.0 * math.pi * (f0 * t + 0.5 * (f1 - f0) * t**2 / duration)
            val = math.sin(phase)
            
            # Fade out at the end to avoid click
            fade_start = 0.8
            if t / duration > fade_start:
                factor = 1.0 - (t / duration - fade_start) / (1.0 - fade_start)
                val *= factor
                
            data = struct.pack('<h', int(val * 32767))
            f.writeframesraw(data)

if __name__ == '__main__':
    generate_chime('pouncio_tune.wav')
    print("pouncio_tune.wav generated successfully!")
