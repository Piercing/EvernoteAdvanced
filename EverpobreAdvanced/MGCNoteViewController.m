//
//  MGCNoteViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 6/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNoteViewController.h"
#import "MGCNote.h"
#import "MGCPhoto.h"
@interface MGCNoteViewController ()
@property(nonatomic, strong)MGCNote *model;
@end

@implementation MGCNoteViewController

#pragma mark - Init
-(id) initWithModel:(MGCNote *)model{
    
    if (self = [super initWithNibName:nil bundle:nil]){
        _model = model;
    }
    return self;
}

#pragma mark - View Lyfecicle
// La ida, cuando se vaya a mostrar la vista sincronizo modelo => vista
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Sicronizo modelo ==> vista
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateStyle = NSDateIntervalFormatterLongStyle;
    
    // muestro en el IBOutlet 'modificationDateView' la fecha de modificación de mi modelo
    self.nameView.text = self.model.name;
    self.textView.text = self.model.text;
    self.modificationDateView.text = [fmt stringFromDate:self.model.modificationDate];
    
    // Ahora la fotito dichosa
    UIImage *img = self.model.photo.image;
    if (!img) {
        img = [UIImage imageNamed:@"photography76"];
    }
    self.photoView.image = img;
}

// La vuelta, a la toritilla Umm rica rica!!!
// Cuando va a desaparecer la imagen el usuario ha
// podido editar algo, la imagen por ejemplo y el
// texto, por tanto sincoronizo vista ==> modelo.
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Vista ==> modelo
    self.model.text = self.textView.text;
    self.model.photo.image = self.photoView.image;  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
