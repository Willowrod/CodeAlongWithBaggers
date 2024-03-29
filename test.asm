// as pointed out by Peter Ped Helcmanovsky, the OPT switches 
// must be indented so please copy this comment as well, which will
// have the correct formatting, also click the Raw button to get plain ascii.
// no copyright patricia dot curtis at luckyredfish.com


                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               // tell the assembler we want it for Spectrum Next
                ORG     0x8000
StackEnd:
                ds      127 
StackStart:     db      0        
//              org StackStart
StartAddress   
MainLoop:       ld      a,0                     // black border
                out     ($fe),a        

// Here DE counts down and D and E are OR-ed to check if the loop has completed.

                ld      de,1000                 // loop for 1000 times just wasting cycles
Loop1:          dec     de                      // take 1 off the 1000
                ld      a,d                     // move it to a register we can or with
                or      e                       // or with e to set the flags
                jp      nz,Loop1 

                ld      a,1                    // change this for different colours
                out     ($fe),a         
                
// do another loop wasting more cycles , this time larger band                
                ld      de,2000
Loop2:          dec     de
                ld      a,d
                or      e
                jp      nz,Loop2
// do the whole thing black and blue again and again
                jp      MainLoop
//end start 
// now we save the compiled file so we can either run it or debug it

                SAVENEX OPEN "test.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                // Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE   