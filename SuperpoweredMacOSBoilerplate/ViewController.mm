//
//  ViewController.m
//  SuperpoweredMacOSBoilerplate
//
//  Created by Thomas Dodds on 2021. 10. 21..
//

#import "ViewController.h"
#import "Superpowered.h"
#import "SuperpoweredSimple.h"
#import "SuperpoweredOSXAudioIO.h"
#import "SuperpoweredGenerator.h"
#import "CustomButton.h"

@interface ViewController ()
@property (nonatomic, strong) SuperpoweredOSXAudioIO *superpowered;
@property (weak) IBOutlet CustomButton *buttonA;
@property (weak) IBOutlet CustomButton *buttonB;
@property (weak) IBOutlet CustomButton *buttonC;
@property (weak) IBOutlet CustomButton *buttonD;
@end



@implementation ViewController {
    Superpowered::Generator *generator;
    float genVolume, genPreviousVolume;
    __weak IBOutlet NSButton *hello;
}

// I would like this to be triggered on mouse down of all the blue buttons, passing in a float as a value for frequency.
-(void)playNote:(float) frequency {
    generator->frequency = frequency;
    genVolume = 1;
    NSLog(@"mouse down: %f", frequency);
}

// I would like this to be triggered on mouse up (and nouse out) of all buttons

-(void)stopNote {
    genVolume = 0;
    NSLog(@"mouse up");
}


- (void)viewDidLoad {
    [super viewDidLoad];

    Superpowered::Initialize(
     "ExampleLicenseKey-WillExpire-OnNextUpdate",
     false, // enableAudioAnalysis (using SuperpoweredAnalyzer, SuperpoweredLiveAnalyzer, SuperpoweredWaveform or SuperpoweredBandpassFilterbank)
     false, // enableFFTAndFrequencyDomain (using SuperpoweredFrequencyDomain, SuperpoweredFFTComplex, SuperpoweredFFTReal or SuperpoweredPolarFFT)
     false, // enableAudioTimeStretching (using SuperpoweredTimeStretching)
     true, // enableAudioEffects (using any SuperpoweredFX class)
     true, // enableAudioPlayerAndDecoder (using SuperpoweredAdvancedAudioPlayer or SuperpoweredDecoder)
     false, // enableCryptographics (using Superpowered::RSAPublicKey, Superpowered::RSAPrivateKey, Superpowered::hasher or Superpowered::AES)
     false  // enableNetworking (using Superpowered::httpRequest)
    );

    // Do any additional setup after loading the view.
    NSLog(@"Superpowered version: %u", Superpowered::Version());
    
    
   
    generator = new Superpowered::Generator(44100, Superpowered::Generator::Sine);
    generator->frequency = 440.0;
    genVolume = 1;
    genPreviousVolume = 1;

    self.superpowered = [[SuperpoweredOSXAudioIO alloc] initWithDelegate:(id<SuperpoweredOSXAudioIODelegate>)self preferredBufferSizeMs:12 numberOfChannels:2 enableInput:true enableOutput:true];
    [self.superpowered start];
    
    // Button event
    self.buttonA.mouseUpBlock = ^{
        [self stopNote];
    };
    self.buttonA.mouseDownBlock = ^{
        [self playNote:200];
    };
    self.buttonB.mouseUpBlock = ^{
        [self stopNote];
    };
    self.buttonB.mouseDownBlock = ^{
        [self playNote:300];
    };
    self.buttonC.mouseUpBlock = ^{
        [self stopNote];
    };
    self.buttonC.mouseDownBlock = ^{
        [self playNote:400];
    };
    self.buttonD.mouseUpBlock = ^{
        [self stopNote];
    };
    self.buttonD.mouseDownBlock = ^{
        [self playNote:600];
    };
}

- (bool)audioProcessingCallback:(float **)inputBuffers inputChannels:(unsigned int)inputChannels outputBuffers:(float **)outputBuffers outputChannels:(unsigned int)outputChannels numberOfFrames:(unsigned int)numberOfFrames samplerate:(unsigned int)samplerate hostTime:(unsigned long long int)hostTime {
    
    float outputBuffer[numberOfFrames * 2];
    
    generator->generate(outputBuffers[0], numberOfFrames);
    
    Superpowered::Interleave(outputBuffers[0], outputBuffers[0], outputBuffer, numberOfFrames);
    
    Superpowered::Volume(
        outputBuffer,
        outputBuffer,
        genPreviousVolume,
        genVolume,
        numberOfFrames
    );
    genPreviousVolume = genVolume;
    
    Superpowered::DeInterleave(outputBuffer, outputBuffers[0], outputBuffers[1], numberOfFrames);

    return true;
}

@end
