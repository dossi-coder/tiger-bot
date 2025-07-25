package com.fffattiger.wechatbot.infrastructure.event;

import org.springframework.context.ApplicationListener;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;

import com.fffattiger.wechatbot.application.service.ListenerApplicationService;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WxAutoConnectedListener implements ApplicationListener<WxAutoConnectedEvent> {

    @Resource
    private ListenerApplicationService listenerApplicationService;

    @Override
    public void onApplicationEvent(@NonNull WxAutoConnectedEvent event) {
        
        listenerApplicationService.findAll().forEach(listenerAggregate -> {
            event.getWxAuto().addListenChat(listenerAggregate.chat().getName(), listenerAggregate.listener().isSavePic(),
                    listenerAggregate.listener().isSaveVoice(), listenerAggregate.listener().isParseLinks());
        });
    }
}
