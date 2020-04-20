package edu.pw.shoppingm8.authentication.social;

import edu.pw.shoppingm8.authentication.api.dto.SocialMediaLoginDto;

public interface SocialMediaService {
    SocialMediaProfileDto getProfile(SocialMediaLoginDto socialMediaLoginDto);

    byte[] getPicture(SocialMediaProfileDto profile);
}