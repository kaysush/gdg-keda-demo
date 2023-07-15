package xyz.sushil.kedademo;

import java.util.Map;
import org.apache.kafka.clients.CommonClientConfigs;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.KafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;

@Configuration
public class KafkaConsumerConfiguration {

  @Value("${spring.kafka.properties.bootstrap.servers}")
  private String bootstrapServers;

  @Value("${spring.kafka.properties.security.protocol}")
  private String securityProtocol;

  @Value("${spring.kafka.properties.sasl.mechanism}")
  private String saslMechanism;

  @Value("${spring.kafka.properties.sasl.jaas.config}")
  private String jaasConfig;

  @Bean
  public Map<String, Object> consumerConfigs() {
    return Map.of(
        ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers,
        CommonClientConfigs.SECURITY_PROTOCOL_CONFIG, securityProtocol,
        SaslConfigs.SASL_MECHANISM, saslMechanism,
        SaslConfigs.SASL_JAAS_CONFIG, jaasConfig,
        ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringSerializer.class,
        ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringSerializer.class
    );
  }

  @Bean
  public ConsumerFactory<String, String> consumerFactory() {
    return new DefaultKafkaConsumerFactory<>(consumerConfigs());
  }


  public KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<String, String>> kafkaListenerContainer() {
    ConcurrentKafkaListenerContainerFactory<String, String> factory =
        new ConcurrentKafkaListenerContainerFactory<>();
    factory.setConsumerFactory(consumerFactory());
    return factory;
  }

}